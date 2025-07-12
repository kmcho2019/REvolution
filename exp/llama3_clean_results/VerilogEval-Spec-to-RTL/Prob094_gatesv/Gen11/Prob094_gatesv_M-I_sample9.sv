module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // out_both calculation: directly assign 0 to out_both[3] and simplify the condition
            assign out_both[i] = (i < 3)? in[i] & in[i+1] : 1'b0;

            // out_any calculation: simplify the condition for out_any[0]
            assign out_any[i] = (i > 0)? (in[i] | in[i-1]) : in[i];

            // out_different calculation: use XOR for simplicity and wrap around for the most significant bit
            assign out_different[i] = in[i] ^ (i == 3)? in[0] : in[i+1];
        end
    endgenerate

endmodule