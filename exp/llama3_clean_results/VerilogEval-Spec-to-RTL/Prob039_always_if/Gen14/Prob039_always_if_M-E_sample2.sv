// Define a module for the LUT-based implementation
module LUTBasedModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_lut
);

// Define a small ROM to store the output values
reg [1:0] lut[3:0];

// Initialize the ROM with the output values
initial begin
    lut[0] = a; // sel_b1 = 0, sel_b2 = 0
    lut[1] = a; // sel_b1 = 0, sel_b2 = 1
    lut[2] = a; // sel_b1 = 1, sel_b2 = 0
    lut[3] = b; // sel_b1 = 1, sel_b2 = 1
end

// Use the ROM to generate the output
always @(*) begin
    if (sel_b1 == 0 && sel_b2 == 0) out_lut = lut[0];
    else if (sel_b1 == 0 && sel_b2 == 1) out_lut = lut[1];
    else if (sel_b1 == 1 && sel_b2 == 0) out_lut = lut[2];
    else out_lut = lut[3];
end

endmodule

// Define a module for the procedural if statement implementation
module ProceduralIfModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_if
);

// Use a procedural if statement to generate the output
always @(*) begin
    if (sel_b1 && sel_b2) out_if = b;
    else out_if = a;
end

endmodule

// The top module encapsulates the LUT-based and procedural if statement modules
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Instantiate the LUT-based module
LUTBasedModule lut_based_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_lut(out_assign)
);

// Instantiate the procedural if statement module
ProceduralIfModule procedural_if_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_if(out_always)
);

endmodule