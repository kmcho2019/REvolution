module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Initialize state to walking left
    end else begin
        case ({bump_left, bump_right})
            2'b00: state <= state;
            2'b01: state <= 1'b1; // Switch to walking left
            2'b10: state <= 1'b0; // Switch to walking right
            2'b11: state <= ~state; // Switch direction
        endcase
    end
end

always_comb begin
    case (state)
        1'b1: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end
        1'b0: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    endcase
end

endmodule