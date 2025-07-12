module TopModule(
    input clk,
    input in,
    output reg out
);

reg q; // Internal signal to hold the flip-flop's output

// The XOR gate's output is the input to the D flip-flop
assign out = q;

always @(posedge clk) begin
    // On the positive edge of the clock, the flip-flop captures the XOR of 'in' and its current output 'out'
    q <= in ^ out;
end

endmodule