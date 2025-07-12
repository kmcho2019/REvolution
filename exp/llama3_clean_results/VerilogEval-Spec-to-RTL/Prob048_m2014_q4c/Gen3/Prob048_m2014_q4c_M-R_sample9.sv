module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

reg next_q; // Temporary variable to hold the next state of q

always @(posedge clk) begin
    if (r) begin
        next_q = 0; // Reset condition
    end else begin
        next_q = d; // Capture input d on the rising edge of clk
    end
    q <= next_q; // Assign the next state to q
end

endmodule