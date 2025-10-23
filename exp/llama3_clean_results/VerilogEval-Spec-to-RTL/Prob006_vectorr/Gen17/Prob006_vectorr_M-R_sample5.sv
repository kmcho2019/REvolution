// Refactored module to reverse the bit ordering of an 8-bit input using a single assignment statement with a loop
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a single assignment statement with a loop to reverse the bits
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

    // Alternatively, a more scalable way to reverse the bits for larger word sizes
    // assign out = {<< {in} };  // Note: This syntax is not supported in all Verilog versions

    // To support all Verilog versions and make it scalable, use a generate block
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign out[i] = in[7 - i];
        end
    endgenerate

endmodule