#define __MainScreenFrame   [[UIScreen mainScreen] bounds]
#define __MainScreen_Width  __MainScreenFrame.size.width
#define __MainScreen_Height __MainScreenFrame.size.height-20

extern NSString *const DB_PATH;

extern NSString *const UM_API_KEY;

extern NSString *const EVENT_CHECKED;
extern NSString *const EVENT_ADD_LIST;
extern NSString *const EVENT_REMOVE_LIST;
extern NSString *const EVENT_ADD_ITEM;
extern NSString *const EVENT_REMOVE_ITEM;