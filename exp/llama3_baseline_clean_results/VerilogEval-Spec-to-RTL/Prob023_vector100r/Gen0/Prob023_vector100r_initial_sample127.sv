module TopModule(
    input [99:0] in,  // 100 bits
    output [99:0] out  // 100 bits
);

// Use a for loop to assign each bit of the output to the corresponding bit from the end of the input
genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin
        assign out[i] = in[99 - i];
    end
endgenerate

endmodule