module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

parameter RESET_POLARITY = 1'b1; // 1=active high, 0=active low

always @(posedge clk or posedge ar) begin
    if (ar == RESET_POLARITY) q <= 1'b0;  // Asynchronous reset
    else                     q <= d;      // Positive edge-triggered data capture
end

endmodule