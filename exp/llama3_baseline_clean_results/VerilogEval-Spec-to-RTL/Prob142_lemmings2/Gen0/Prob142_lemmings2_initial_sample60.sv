module TopModule(
    input         clk,
    input         areset,
    input         bump_left,
    input         bump_right,
    input         ground,
    output        walk_left,
    output        walk_right,
    output        aaah
);

// Define the states
enum logic [1:0] {
    WL = 2'b00, // Walking Left
    WR = 2'b01, // Walking Right
    FL = 2'b10, // Falling Left
    FR = 2'b11  // Falling Right
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WL;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    // Default values
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
        WL: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = WR;
            end else if (!ground) begin
                next_state = FL;
            end else if (bump_right) begin
                next_state = WR;
            end
        end
        WR: begin
            walk_right = 1'b1;
            if (bump_right) begin
                next_state = WL;
            end else if (!ground) begin
                next_state = FR;
            end else if (bump_left) begin
                next_state = WL;
            end
        end
        FL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground) begin
                next_state = WL;
            end
        end
        FR: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            if (ground) begin
                next_state = WR;
            end
        end
        default: begin
            next_state = WL;
        end
    endcase
end

endmodule