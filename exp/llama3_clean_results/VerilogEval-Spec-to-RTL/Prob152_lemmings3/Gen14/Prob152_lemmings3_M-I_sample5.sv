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

// Using binary encoding for states to potentially reduce area
reg [1:0] state, next_state;
reg walk_direction, next_walk_direction;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALKING
        walk_direction <= 0;
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;

    case (state)
        2'b00: // WALKING
            if (!ground) begin
                next_state = 2'b01; // FALLING
            end else if (dig) begin
                next_state = 2'b10; // DIGGING
            end else if (bump_left) begin
                next_walk_direction = 1;
            end else if (bump_right) begin
                next_walk_direction = 0;
            end
        2'b01: // FALLING
            if (ground) begin
                next_state = 2'b00; // WALKING
            end
        2'b10: // DIGGING
            if (!ground) begin
                next_state = 2'b01; // FALLING
            end
    endcase
end

// Simplifying output logic to reduce area and improve performance
assign walk_left = (state == 2'b00 && !walk_direction);
assign walk_right = (state == 2'b00 && walk_direction);
assign aaah = (state == 2'b01);
assign digging = (state == 2'b10);

endmodule