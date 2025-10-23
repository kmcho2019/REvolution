module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // State encoding
    localparam WALK = 1'b0;
    localparam FALL = 1'b1;
    
    reg state;      // Current state
    reg direction;  // 0=left, 1=right
    
    // Next state and direction wires
    wire next_state;
    wire next_direction;
    
    // Next state logic
    assign next_state = (!ground && (state == WALK)) ? FALL : 
                       (ground && (state == FALL)) ? WALK : 
                       state;
    
    // Next direction logic
    assign next_direction = (state == WALK && ground) ? 
                           ((!direction && bump_left) || (direction && bump_right) ? ~direction : direction) :
                           direction;
    
    // State and direction registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK;
            direction <= 0;
        end else begin
            state <= next_state;
            direction <= next_direction;
        end
    end
    
    // Output logic (registered)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end else begin
            walk_left <= (state == WALK) && !direction;
            walk_right <= (state == WALK) && direction;
            aaah <= (state == FALL);
        end
    end

endmodule