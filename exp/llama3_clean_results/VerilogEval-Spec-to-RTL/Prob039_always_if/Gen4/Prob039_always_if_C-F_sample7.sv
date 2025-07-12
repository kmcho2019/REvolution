// Define a module for the direct assignment logic using LUT concept
module DirectAssignModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign
);

assign out_assign = (sel_b1 && sel_b2) ? b : a;

endmodule

// Define a module for the procedural assignment logic using LUT concept
module ProceduralAssignModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_always
);

always @(*) begin
    case ({sel_b1, sel_b2})
        2'b00: out_always <= a;
        2'b01: out_always <= a;
        2'b10: out_always <= a;
        2'b11: out_always <= b;
        default: out_always <= a;
    endcase
end

endmodule

// The top module encapsulates the direct and procedural assignment modules
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
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