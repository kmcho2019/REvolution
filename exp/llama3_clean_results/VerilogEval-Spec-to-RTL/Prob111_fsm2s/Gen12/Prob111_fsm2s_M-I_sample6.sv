module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

always @(posedge clk) begin
    if (reset) begin
        out <= 0; // Reset to OFF state
    end else if (out == 1) begin // Currently in ON state
        if (k == 1) begin
            out <= 0; // Transition to OFF state
        end
    end else begin // Currently in OFF state
        if (j == 1) begin
            out <= 1; // Transition to ON state
        end
    end
end

endmodule