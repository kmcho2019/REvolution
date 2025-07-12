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

    // State encoding
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [1:0] state, next_state;
    reg direction;  // 0=left, 1=right

    // Next state logic
    always @(*) begin
        case (state)
            WALK: begin
                if (~ground) begin
                    next_state = FALL;  // Highest priority: fall
                end else if (dig) begin
                    next_state = DIG;   // Medium priority: dig
                end else begin
                    next_state = WALK;  // Stay walking unless bumped
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_state = WALK;  // Return to walking when ground returns
                end else begin
                    next_state = FALL;  // Keep falling
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_state = FALL;  // Start falling when ground disappears
                end else begin
                    next_state = DIG;   // Keep digging
                end
            end
            
            default: next_state = WALK;
        endcase
    end

    // Direction update logic (only when walking)
    wire direction_update;
    assign direction_update = (state == WALK) && 
                             ((bump_left && ~direction) || 
                              (bump_right && direction) ||
                              (bump_left && bump_right));

    // State and direction registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;  // Start walking left
        end else begin
            state <= next_state;
            
            // Only update direction when walking and bumped
            if (direction_update) begin
                if (bump_left && bump_right) begin
                    direction <= ~direction;  // Toggle if both bumps
                end else if (bump_left) begin
                    direction <= 1'b1;      // Change to right
                end else if (bump_right) begin
                    direction <= 1'b0;       // Change to left
                end
            end
        end
    end

    // Output logic
    assign walk_left  = (state == WALK) && ~direction;
    assign walk_right = (state == WALK) && direction;
    assign aaah       = (state == FALL);
    assign digging    = (state == DIG);

endmodule