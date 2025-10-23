module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states
enum logic [1:0] {
    walking_left = 2'b00,
    walking_right = 2'b01,
    falling_left = 2'b10,
    falling_right = 2'b11
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
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
    
    case (state)
        walking_left: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_right;
            end else if (~ground) begin
                next_state = falling_left;
            end
        end
        walking_right: begin
            walk_right = 1'b1;
            if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_left;
            end else if (~ground) begin
                next_state = falling_right;
            end
        end
        falling_left: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground) begin
                next_state = walking_left;
            end
        end
        falling_right: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground) begin
                next_state = walking_right;
            end
        end
    endcase
end

endmodule