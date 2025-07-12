module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 2 bits to represent the state (00: walking left, 01: walking right, 10: falling left, 11: falling right)
reg [1:0] next_state;

// Simplified combinational logic to determine the next state
always @(*) begin
    next_state = state;
    
    case(state)
        2'b00: // walking left
            begin
                if (~ground) next_state = 2'b10;
                else if (bump_left) next_state = 2'b01;
            end
        2'b01: // walking right
            begin
                if (~ground) next_state = 2'b11;
                else if (bump_right) next_state = 2'b00;
            end
        2'b10, 2'b11: // falling
            begin
                if (ground) next_state = state == 2'b10 ? 2'b00 : 2'b01;
            end
    endcase
    
    // Handle bumps when falling
    if (state == 2'b10 && bump_right) next_state = 2'b11;
    if (state == 2'b11 && bump_left) next_state = 2'b10;
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to walking left
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    case(state)
        2'b00, 2'b10: // walking or falling left
            begin
                walk_left = 1'b1;
                walk_right = 1'b0;
            end
        2'b01, 2'b11: // walking or falling right
            begin
                walk_left = 1'b0;
                walk_right = 1'b1;
            end
    endcase
    
    // Determine aaah based on state
    aaah = state[1] ? 1'b1 : 1'b0;
end

endmodule