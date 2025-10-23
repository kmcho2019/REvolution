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

    // One-hot state encoding
    parameter WALKING = 3'b001;
    parameter FALLING = 3'b010;
    parameter DIGGING = 3'b100;
    
    reg [2:0] state;
    reg direction;  // 0=left, 1=right

    // Next state and direction logic
    wire [2:0] next_state;
    wire next_direction;

    // State transitions
    assign next_state = 
        (state == WALKING) ? 
            (!ground ? FALLING : 
             (dig ? DIGGING : WALKING)) :
        (state == FALLING) ? 
            (ground ? WALKING : FALLING) :
        (state == DIGGING) ? 
            (!ground ? FALLING : DIGGING) :
        WALKING;  // default

    // Direction changes (only in WALKING state when not transitioning)
    assign next_direction = 
        (state != WALKING || !ground || dig) ? direction :  // maintain direction if not walking normally
        (bump_left && !direction) ? 1'b1 :  // switch to right
        (bump_right && direction) ? 1'b0 :  // switch to left
        direction;  // default keep direction

    // State and direction registers with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
            direction <= 1'b0; // start walking left
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end

    // Output logic
    assign walk_left = (state == WALKING) & ~direction;
    assign walk_right = (state == WALKING) & direction;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule