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

// Define the states
logic [1:0] state, next_state;

// Assign initial state
initial state = 2'b00;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to WALK_LEFT state
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    if (state == 2'b00) begin // WALK_LEFT
        walk_left = 1'b1;
        if (!ground) begin
            next_state = 2'b10; // FALLING
        end else if (dig) begin
            next_state = 2'b11; // DIGGING
        end else if (bump_left || bump_right) begin
            next_state = 2'b01; // WALK_RIGHT
        end
    end else if (state == 2'b01) begin // WALK_RIGHT
        walk_right = 1'b1;
        if (!ground) begin
            next_state = 2'b10; // FALLING
        end else if (dig) begin
            next_state = 2'b11; // DIGGING
        end else if (bump_left || bump_right) begin
            next_state = 2'b00; // WALK_LEFT
        end
    end else if (state == 2'b10) begin // FALLING
        aaah = 1'b1;
        if (ground) begin
            next_state = (state == 2'b10)? 2'b00 : 2'b01; // Resume walking
        end
    end else if (state == 2'b11) begin // DIGGING
        digging = 1'b1;
        if (!ground) begin
            next_state = 2'b10; // FALLING
        end
    end
end

endmodule