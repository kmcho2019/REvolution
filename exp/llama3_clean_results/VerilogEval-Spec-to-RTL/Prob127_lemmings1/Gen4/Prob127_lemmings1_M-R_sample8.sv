module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output reg walk_left,
    output reg walk_right
);

reg [0:0] state, next_state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // LEFT state
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        1'b0: // LEFT state
            if (bump_left) begin
                next_state = 1'b1; // RIGHT state
            end else if (bump_right) begin
                next_state = 1'b0; // Stay in LEFT state
            end else begin
                next_state = 1'b0; // Stay in LEFT state
            end
        1'b1: // RIGHT state
            if (bump_right) begin
                next_state = 1'b0; // LEFT state
            end else if (bump_left) begin
                next_state = 1'b1; // Stay in RIGHT state
            end else begin
                next_state = 1'b1; // Stay in RIGHT state
            end
        default:
            next_state = 1'b0; // LEFT state
    endcase

    // Simplified logic to handle bump_left && bump_right condition
    if (bump_left && bump_right) begin
        next_state = ~state; // Switch direction
    end
end

assign walk_left = (state == 1'b0) ? 1'b1 : 1'b0;
assign walk_right = (state == 1'b1) ? 1'b1 : 1'b0;

endmodule