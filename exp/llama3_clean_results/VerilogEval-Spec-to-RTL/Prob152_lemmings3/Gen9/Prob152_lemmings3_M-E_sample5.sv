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

// Define the states using one-hot encoding
reg [3:0] state;
reg [3:0] next_state;

// Define the walking directions
reg walk_direction;
reg next_walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 4'b0001; // Initialize to walking left state
        walk_direction <= 1'b0; // Initialize to walking left
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
        4'b0001: begin // Walking left state
            if (!ground) begin
                next_state = 4'b0010; // Transition to falling state
            end else if (dig) begin
                next_state = 4'b0100; // Transition to digging state
            end else if (bump_left) begin
                next_walk_direction = 1'b1; // Switch to walking right
            end else if (bump_right) begin
                next_walk_direction = 1'b0; // Switch to walking left
            end
        end
        4'b0010: begin // Falling state
            if (ground) begin
                next_state = 4'b0001; // Transition to walking left state
            end
        end
        4'b0100: begin // Digging state
            if (!ground) begin
                next_state = 4'b0010; // Transition to falling state
            end
        end
        4'b1000: begin // Walking right state
            if (!ground) begin
                next_state = 4'b0010; // Transition to falling state
            end else if (dig) begin
                next_state = 4'b0100; // Transition to digging state
            end else if (bump_left) begin
                next_walk_direction = 1'b1; // Switch to walking right
            end else if (bump_right) begin
                next_walk_direction = 1'b0; // Switch to walking left
            end
        end
    endcase
end

// Output logic
assign walk_left = (state == 4'b0001 && walk_direction == 1'b0) ? 1'b1 : 1'b0;
assign walk_right = (state == 4'b1000 && walk_direction == 1'b1) ? 1'b1 : 1'b0;
assign aaah = (state == 4'b0010) ? 1'b1 : 1'b0;
assign digging = (state == 4'b0100) ? 1'b1 : 1'b0;

endmodule