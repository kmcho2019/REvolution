// Define a module for the combinational logic circuit
module CombinationalMux(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign
);

// Use a single assign statement to reduce logic complexity
assign out_assign = (sel_b1 && sel_b2) ? b : a;

endmodule

// Define a module for the sequential logic circuit
module SequentialMux(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output logic out_always
);

// Use a single always block to reduce logic complexity
always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule

// The top module encapsulates the combinational and sequential logic circuits
module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output logic out_always
);

// Instantiate the combinational logic circuit
CombinationalMux combinational_mux(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_assign(out_assign)
);

// Instantiate the sequential logic circuit
SequentialMux sequential_mux(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out_always(out_always)
);

endmodule