// Define a submodule for the LUT implementation
module LUTModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_lut
);

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b00: out_lut = a;
        2'b01: out_lut = a;
        2'b10: out_lut = a;
        2'b11: out_lut = b;
    endcase
end

endmodule

// Define a submodule for the direct assignment implementation
module DirectModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_direct
);

assign out_direct = (sel_b1 && sel_b2) ? b : a;

endmodule

// The top module encapsulates the LUT and direct assignment modules
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

// Instantiate the direct assignment module
DirectModule direct_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_direct(out_assign)
);

// Instantiate the LUT module
LUTModule lut_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_lut(out_always)
);

endmodule