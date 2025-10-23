module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Action states
    localparam [1:0]
        WALK  = 2'b00,
        FALL  = 2'b01,
        DIG   = 2'b10,
        SPLAT = 2'b11;

    reg [1:0] action, next_action;
    reg direction;  // 0=left, 1=right
    reg next_direction;
    reg [4:0] fall_counter;

    // State transitions with synchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action <= WALK;
            direction <= 0;  // start walking left
            fall_counter <= 0;
        end else begin
            action <= next_action;
            direction <= next_direction;
            
            // Update fall counter
            if (action == FALL) begin
                fall_counter <= ground ? 0 : fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic - implemented with assign for clarity
    assign next_action = 
        (action == SPLAT) ? SPLAT :  // Once splat, stay splat
        (~ground) ? FALL :           // Highest priority: falling
        ((action == WALK) && dig) ? DIG :  // Dig only from walking
        action;                      // Default: maintain current action

    // Next direction logic
    assign next_direction = 
        (action == SPLAT) ? direction :  // Keep direction even when splat
        (~ground) ? direction :          // Keep direction when falling
        (action == DIG) ? direction :    // Keep direction when digging
        (action == WALK) ?               // Only change direction when walking
            (bump_left ? 1'b1 : 
             bump_right ? 1'b0 : 
             direction) :
        direction;

    // Handle splat condition when landing from fall
    always @(*) begin
        if (action == FALL && ground) begin
            next_action = (fall_counter > 20) ? SPLAT : WALK;
        end
    end

    // Output logic
    assign walk_left = (action == WALK) & ~direction;
    assign walk_right = (action == WALK) & direction;
    assign aaah = (action == FALL);
    assign digging = (action == DIG);

endmodule