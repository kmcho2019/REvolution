module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Module for out_both
module out_both_module(
    input [99:0] in,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out[i] = (i == 99) ? 0 : (in[i] && in[i+1]);
        end
    endgenerate
endmodule

// Module for out_any
module out_any_module(
    input [99:0] in,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out[i] = (i == 0) ? 0 : (in[i] || in[i-1]);
        end
    endgenerate
endmodule

// Module for out_different
module out_different_module(
    input [99:0] in,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
        end
    endgenerate
endmodule

out_both_module both_module(.in(in), .out(out_both));
out_any_module any_module(.in(in), .out(out_any));
out_different_module different_module(.in(in), .out(out_different));

endmodule