// Define a module for the LUT-based multiplexer
module LUTBasedMux(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_lut
);

// Define a lookup table (LUT) to store output values for all possible input combinations
logic [1:0] lut_output;

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b00: lut_output = a;
        2'b01: lut_output = a;
        2'b10: lut_output = a;
        2'b11: lut_output = b;
        default: lut_output = 1'bx; // Default value for invalid input combinations
    endcase

    // Assign the output value from the LUT
    out_lut = lut_output;
end

endmodule

// Define a module for the direct assignment logic
module DirectAssignModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign
);

assign out_assign = (sel_b1 && sel_b2) ? b : a;

endmodule

// Define a module for the procedural assignment logic
module ProceduralAssignModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_always
);

always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule

// The top module encapsulates the LUT-based, direct assignment, and procedural assignment modules
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always,
    output logic out_lut
);

// Instantiate the LUT-based multiplexer module
LUTBasedMux lut_based_mux(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_lut(out_lut)
);

// Instantiate the direct assignment module
DirectAssignModule direct_assign_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_assign(out_assign)
);

// Instantiate the procedural assignment module
ProceduralAssignModule procedural_assign_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_always(out_always)
);

endmodule