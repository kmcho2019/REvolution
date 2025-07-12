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
reg direction, next_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // WALKING
        direction <= 1'b0; // LEFT
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    next_direction = direction;

    if (state == 2'b01) begin // WALKING
        if (!ground) begin
            next_state = 2'b00; // FALLING
        end else if (dig) begin
            next_state = 2'b10; // DIGGING
        end else if (bump_left &&!direction) begin
            next_direction = 1'b1; // RIGHT
        end else if (bump_right && direction) begin
            next_direction = 1'b0; // LEFT
        end
    end else if (state == 2'b00) begin // FALLING
        if (ground) begin
            next_state = 2'b01; // WALKING
        end
    end else if (state == 2'b10) begin // DIGGING
        if (!ground) begin
            next_state = 2'b00; // FALLING
        end
    end
end

// Output logic
always_comb begin
    walk_left = (state == 2'b01 &&!direction);
    walk_right = (state == 2'b01 && direction);
    aaah = (state == 2'b00);
    digging = (state == 2'b10);
end

endmodule