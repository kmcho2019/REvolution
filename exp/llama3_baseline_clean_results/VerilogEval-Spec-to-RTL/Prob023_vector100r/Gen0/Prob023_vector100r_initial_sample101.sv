module TopModule(
    input  [99:0] in,  // 100-bit input
    output [99:0] out  // 100-bit output
);

assign out = in[99:0];  // Reverse the bit ordering

// But since Verilog doesn't support direct reverse assignment of a vector like this
// we need to use a loop or assign each bit individually. However, for a one-to-one 
// reversal like this, a simple loop or bit-by-bit assignment in a generate block 
// can achieve the desired result. Here is how to do it properly:

// Using a loop in a initial block does not work for continuous assignment
// But we can use a generate block for the purpose:

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin
        assign out[i] = in[99-i];
    end
endgenerate

endmodule