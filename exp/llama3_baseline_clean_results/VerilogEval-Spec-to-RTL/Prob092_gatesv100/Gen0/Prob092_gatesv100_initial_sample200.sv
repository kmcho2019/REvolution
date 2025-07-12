module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    // Handle out_both
    for (i = 0; i <= 98; i++) begin
        assign out_both[i] = in[i] & in[i+1];
    end
    assign out_both[99] = 1'b0;  // As per problem statement, no left neighbor for in[99]

    // Handle out_any
    for (i = 1; i <= 99; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end
    assign out_any[0] = 1'b0;  // As per problem statement, no right neighbor for in[0]

    // Handle out_different
    for (i = 0; i <= 98; i++) begin
        assign out_different[i] = in[i] ^ in[i+1];
    end
    assign out_different[99] = in[99] ^ in[0];  // Wrap-around for the most significant bit
endgenerate

endmodule