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

// Walking direction state machine
reg [1:0] walk_state, next_walk_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_state <= 2'b00; // Initialize to left
    end else begin
        walk_state <= next_walk_state;
    end
end

always_comb begin
    next_walk_state = walk_state;
    case (walk_state)
        2'b00: // Left
            if (bump_left) begin
                next_walk_state = 2'b01; // Switch to right
            end
        2'b01: // Right
            if (bump_right) begin
                next_walk_state = 2'b00; // Switch to left
            end
    endcase
end

// Main state machine
reg [1:0] state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Initialize to walking
    end else begin
        state <= next_state;
    end
end

always_comb begin
    next_state = state;
    case (state)
        2'b00: // Walking
            if (!ground) begin
                next_state = 2'b01; // Fall
            end else if (dig) begin
                next_state = 2'b10; // Dig
            end
        2'b01: // Falling
            if (ground) begin
                next_state = 2'b00; // Resume walking
            end
        2'b10: // Digging
            if (!ground) begin
                next_state = 2'b01; // Fall
            end
    endcase
end

// Output logic
always_comb begin
    walk_left = (walk_state == 2'b00) && (state == 2'b00);
    walk_right = (walk_state == 2'b01) && (state == 2'b00);
    aaah = (state == 2'b01);
    digging = (state == 2'b10);
end

endmodule