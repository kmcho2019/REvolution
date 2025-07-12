module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    // Calculate out_both
    generate
        for (i = 0; i < 100; i++) begin
            assign out_both[i] = (i < 99) ? (in[i] & in[i+1]) : 1'b0;
        end
    endgenerate

    // Calculate out_any
    generate
        for (i = 0; i < 100; i++) begin
            assign out_any[i] = (i > 0) ? (in[i] | in[i-1]) : 1'b0;
        end
    endgenerate

    // Calculate out_different
    generate
        for (i = 0; i < 100; i++) begin
            assign out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    endgenerate

endmodule