module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0;
    end else begin
        case (state)
            1'b0: if (j) begin state <= 1'b1; out <= 1'b1; end else begin state <= 1'b0; out <= 1'b0; end
            1'b1: if (k) begin state <= 1'b0; out <= 1'b0; end else begin state <= 1'b1; out <= 1'b1; end
        endcase
    end
end

endmodule