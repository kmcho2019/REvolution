module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_prev; // Internal signal to hold the previous output value

always @(*) begin
    // The XOR operation between 'in' and the previous 'out'
    out_prev = out;
end

always @(posedge clk) begin
    // The D flip-flop capturing the XOR result on the positive edge of 'clk'
    out <= in ^ out_prev;
end

endmodule