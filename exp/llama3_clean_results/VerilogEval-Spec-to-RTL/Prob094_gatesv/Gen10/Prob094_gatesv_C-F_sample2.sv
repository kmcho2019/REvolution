// Module for out_both operation
module out_both_module(
    input  [3:0] in,
    output [3:0] out
);
    assign out[2] = in[2] & in[3];
    assign out[1] = in[1] & in[2];
    assign out[0] = in[0] & in[1];
    assign out[3] = 1'b0; // Since there's no left neighbor for in[3]
endmodule

// Module for out_any operation
module out_any_module(
    input  [3:0] in,
    output [3:0] out
);
    assign out[0] = in[0];
    assign out[1] = in[1] | in[0];
    assign out[2] = in[2] | in[1];
    assign out[3] = in[3] | in[2];
endmodule

// Module for out_different operation
module out_different_module(
    input  [3:0] in,
    output [3:0] out
);
    assign out[0] = in[0] ^ in[3]; // Wrap-around for the least significant bit
    assign out[1] = in[1] ^ in[0];
    assign out[2] = in[2] ^ in[1];
    assign out[3] = in[3] ^ in[2];
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