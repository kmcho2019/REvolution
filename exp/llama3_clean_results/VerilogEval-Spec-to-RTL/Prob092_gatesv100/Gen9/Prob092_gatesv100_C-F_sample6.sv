module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            // Using bitwise AND for out_both computation
            assign out_both[i] = (i < 99)? (in[i] & in[i+1]) : 1'b0;
            
            // Using logical OR for out_any computation to handle the case where i is 0
            assign out_any[i] = (i > 0)? (in[i] || in[i-1]) : 1'b0;
            
            // Handling the wrap-around case for out_different
            assign out_different[i] = in[i] ^ ((i == 99)? in[0] : in[i+1]);
        end
    endgenerate

endmodule