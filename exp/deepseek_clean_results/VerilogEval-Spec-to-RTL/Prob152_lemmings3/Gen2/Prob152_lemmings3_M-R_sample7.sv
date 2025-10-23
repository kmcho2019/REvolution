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
    
    reg [2:0] state, next_state;
    reg direction, next_direction; // 0=left, 1=right

    // Next state logic (combinational)
    assign next_state = (state == WALKING) ? 
                        (!ground ? FALLING : 
                         (dig ? DIGGING : WALKING)) :
                       (state == FALLING) ? 
                        (ground ? WALKING : FALLING) :
                       (state == DIGGING) ? 
                        (!ground ? FALLING : DIGGING) : 
                        WALKING; // default

    // Next direction logic (combinational)
    assign next_direction = (state == WALKING && ground && !dig) ? 
                           ((bump_left && !direction) ? 1'b1 :
                            (bump_right && direction) ? 1'b0 :
                            direction) :
                           direction; // maintain direction in other states

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALKING;
        end else begin
            state <= next_state;
        end
    end

    // Direction register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // start walking left
        end else begin
            direction <= next_direction;
        end
    end

    // Output logic
    assign walk_left = (state == WALKING) & ~direction;
    assign walk_right = (state == WALKING) & direction;
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule