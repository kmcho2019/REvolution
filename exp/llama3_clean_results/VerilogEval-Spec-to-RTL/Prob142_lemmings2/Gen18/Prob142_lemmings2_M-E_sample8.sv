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

reg [1:0] state;
reg [1:0] next_state;
reg [1:0] direction;

// Combinational logic to determine the next state
always @(*) begin
    next_state = state;

    case(state)
        2'b00: // WALK_LEFT
            if (~ground) begin
                next_state = 2'b10; // FALL_LEFT
            end else if (bump_left) begin
                next_state = 2'b01; // WALK_RIGHT
            end
        2'b01: // WALK_RIGHT
            if (~ground) begin
                next_state = 2'b11; // FALL_RIGHT
            end else if (bump_right) begin
                next_state = 2'b00; // WALK_LEFT
            end
        2'b10: // FALL_LEFT
            if (ground) begin
                next_state = 2'b00; // WALK_LEFT
            end
        2'b11: // FALL_RIGHT
            if (ground) begin
                next_state = 2'b01; // WALK_RIGHT
            end
    endcase

    if (bump_left && state == 2'b01) begin
        next_state = 2'b00; // WALK_LEFT
    end else if (bump_right && state == 2'b00) begin
        next_state = 2'b01; // WALK_RIGHT
    end
end

// Sequential logic to update the state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALK_LEFT
    end else begin
        state <= next_state;
    end
end

// Output logic
always @(*) begin
    walk_left = (state == 2'b00);
    walk_right = (state == 2'b01);
    aaah = (state == 2'b10 || state == 2'b11);
end

endmodule