// Module for out_both operation
module out_both_module(
    input  [3:0] in,
    output [3:0] out
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign out[i] = (i < 3) ? (in[i] & in[i+1]) : 1'b0;
        end
    endgenerate
endmodule

// Module for out_any operation
module out_any_module(
    input  [3:0] in,
    output [3:0] out
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign out[i] = (i == 0) ? in[i] : (in[i] | in[i-1]);
        end
    endgenerate
endmodule

// Module for out_different operation
module out_different_module(
    input  [3:0] in,
    output [3:0] out
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            assign out[i] = (i == 3) ? (in[i] ^ in[0]) : (in[i] ^ in[i+1]);
        end
    endgenerate
endmodule

// TopModule instantiating the separate modules
module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    out_both_module both_module(.in(in), .out(out_both));
    out_any_module any_module(.in(in), .out(out_any));
    out_different_module different_module(.in(in), .out(out_different));
endmodule