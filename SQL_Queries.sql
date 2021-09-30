# If we want to do some paid promotions we can have a look at people with most liked images to ask them for promoting the ad.

SELECT 
    username, COUNT(l.created_at) no_of_likes
FROM
    likes l
        INNER JOIN
    users u ON l.user_id = u.id
GROUP BY user_id
ORDER BY no_of_likes DESC
LIMIT 15;



# If we want to do some paid promotions we can also have a look at people with most followers to ask them for promoting the ad.
SELECT 
    username, COUNT(DISTINCT follower_id) AS number_of_followers
FROM
    follows f
        INNER JOIN
    users u ON u.id = f.followee_id
GROUP BY followee_id
ORDER BY number_of_followers DESC
LIMIT 10;


# Checking out the users with most commentes on their photo to understand the interaction of the followers on the followee page

SELECT 
    u.id,
    p.image_url AS URL,
    COUNT(c.created_at) AS no_of_comments
FROM
    comments c
        INNER JOIN
    photos p ON p.id = c.photo_id
        INNER JOIN
    users u ON c.user_id = u.id
GROUP BY photo_id
ORDER BY no_of_comments DESC
LIMIT 10;



#If we want to target our inactive users with an email campaign let's get the information of users with no photos posted
SELECT 
    user_id, username, users.created_at AS user_joining_date
FROM
    users u
        LEFT JOIN
    photos p ON p.user_id = u.id
GROUP BY u.id
HAVING no_of_photos = 0
ORDER BY no_of_photos , username;



# If I am working at a company and we need to figure out what days of week do most users register on so we can schedule an ad campaign accordingly
SELECT 
    DAYNAME(created_at) AS day_of_the_week,
    COUNT(*) AS total_count
FROM
    users
GROUP BY day_of_the_week
ORDER BY total_count DESC , day_of_the_week;



# The investors wants to know the number of times an average user posts
SELECT 
    ROUND((SELECT 
                    COUNT(*)
                FROM
                    photos) / (SELECT 
                    COUNT(*)
                FROM
                    users)) AS abg_num_of_posts;



# A brand wants to publish a new product and wants to know what are the most common hastags that they can use in the post
SELECT 
    t.id, t.tag_name, COUNT(*) AS no_of_tags
FROM
    tags t
        JOIN
    photo_tags pt ON t.id = pt.tag_id
GROUP BY t.id
ORDER BY no_of_tags DESC
LIMIT 5;


/**
 * We have a small problem with bots on our site...
 * Find number of users who have liked every single photo on the site?
 **/
 
SELECT 
    users.id AS user_id,
    users.username,
    COUNT(*) AS total_user_likes
FROM
    users
        JOIN
    likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_user_likes = (SELECT 
        COUNT(*)
    FROM
        photos);
        


# If we want to capmpaing an add we want to see the average number of tags that a average user has in a photo

SELECT 
    p.id, COUNT(pt.tag_id) AS no_of_tags
FROM
    photos p
        JOIN
    photo_tags pt ON pt.photo_id = p.id
GROUP BY pt.photo_id
ORDER BY no_of_tags DESC;



# Now we want to post an ad campaign and sowe wan to know which hours in a day are most active so we can post the ad accordingly
# Now as we know the activities in our database would be to post_photos, likes, follows,tags,comments.
# We are excluding the creation of a user to get a better understanding of the results


WITH activity_cte AS(
SELECT 
    created_at AS activity_time,
    HOUR(created_at) AS hour_of_day,
    'photos' AS type_of_activity
FROM
    photos 
UNION ALL SELECT 
    created_at, HOUR(created_at), 'comments'
FROM
    comments 
UNION ALL SELECT 
    created_at, HOUR(created_at), 'likes'
FROM
    likes 
UNION ALL SELECT 
    created_at, HOUR(created_at), 'follow'
FROM
    follows 
UNION ALL SELECT 
    created_at, HOUR(created_at), 'tag'
FROM
    tags
)

SELECT 
    hour_of_day, COUNT(*) no_of_activities
FROM
    activity_cte;
    


# Now we want to find the influencers on our platform and we have the budget to approach approx 5 influencers how to decide which one whould we approach
/* There are certain criteria that will help us decide which influencer are active and famous among their user base
1. Total Number of followers
2. Avg Number of likes for each post
3. Total Number of photos(to determine how active they are)
4. How many times their photos are tagged by some other users
5. Avg number of comments in each posts
*/


WITH users_photo_info AS(
SELECT 
    p.user_id,
    COUNT(DISTINCT p.id) AS no_of_photos,
    ROUND(COUNT(l.created_at) / COUNT(DISTINCT p.id)) AS avg_no_of_likes,
    ROUND(COUNT(DISTINCT c.id) / COUNT(DISTINCT p.id)) AS avg_comment_per_photo
FROM
    photos p
        JOIN
    comments c ON c.photo_id = p.id
        JOIN
    likes l ON l.photo_id = p.id
GROUP BY p.user_id
-- ORDER BY no_of_photos DESC , avg_no_of_likes DESC , avg_comment_per_photo DESC
)
,followers_info AS(
SELECT 
    u.id,
    u.username,
    COUNT(DISTINCT f.follower_id) AS no_of_followers
FROM
    users u
        JOIN
    follows f ON f.followee_id = u.id
GROUP BY u.id
-- ORDER BY no_of_followers DESC
)

SELECT 
    fi.username,
    fi.no_of_followers,
    upi.no_of_photos,
    upi.avg_no_of_likes,
    upi.avg_comment_per_photo
FROM
    followers_info fi
        JOIN
    users_photo_info upi ON upi.user_id = fi.id
ORDER BY fi.no_of_followers DESC , upi.no_of_photos DESC , upi.avg_no_of_likes DESC , upi.avg_comment_per_photo DESC
LIMIT 5;