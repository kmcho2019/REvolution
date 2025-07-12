module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state, next_state;
reg walk_direction, next_walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // WALKING
        walk_direction <= 1'b0; // LEFT
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;
    
    case (state)
        2'b01: // WALKING
            if (!ground) begin
                next_state = 2'b00; // FALLING
            end else if (dig) begin
                next_state = 2'b10; // DIGGING
            end else if (bump_left) begin
                next_walk_direction = 1'b1; // RIGHT
            end else if (bump_right) begin
                next_walk_direction = 1'b0; // LEFT
            end
        2'b00: // FALLING
            if (ground) begin
                next_state = 2'b01; // WALKING
            end
        2'b10: // DIGGING
            if (!ground) begin
                next_state = 2'b00; // FALLING
            end
    endcase
end

// Output logic
assign walk_left = (state == 2'b01 && !walk_direction) ? 1'b1 : 1'b0;
assign walk_right = (state == 2'b01 && walk_direction) ? 1'b1 : 1'b0;
assign aaah = (state == 2'b00) ? 1'b1 : 1'b0;
assign digging = (state == 2'b10) ? 1'b1 : 1'b0;

endmodule