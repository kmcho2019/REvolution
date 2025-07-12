module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            // Simplify the logic for out_both
            assign out_both[i] = (i < 99) ? (in[i] & in[i+1]) :'b0;
            
            // Simplify the logic for out_any
            assign out_any[i] = (i > 0) ? (in[i] | in[i-1]) : 1'b0;
            
            // Simplify the logic for out_different and handle the wrap-around case
            assign out_different[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
        end
    endgenerate

endmodule