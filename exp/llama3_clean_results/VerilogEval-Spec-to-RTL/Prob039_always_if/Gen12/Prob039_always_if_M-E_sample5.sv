// Define a parameterizable module for the 2-to-1 mux logic
module MuxModule #(
    parameter USE_ASSIGN = 1 // 1 for assign statement, 0 for procedural if statement
)(
    input  logic a,
    input  logic b,
    input  logic sel_b1,
    input  logic sel_b2,
    output logic out
);

generate
    if (USE_ASSIGN) begin
        // Use assign statement
        assign out = (sel_b1 && sel_b2) ? b : a;
    end else begin
        // Use procedural if statement
        always @(*) begin
            out = (sel_b1 && sel_b2) ? b : a;
        end
    end
endgenerate

endmodule

// Define the top module
module TopModule(
    input  logic a,
    input  logic b,
    input  logic sel_b1,
    input  logic sel_b2,
    output logic out_assign,
    output logic out_always
);

// Instantiate the mux module using assign statement
MuxModule assign_module(
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out(out_assign)
);

// Instantiate the mux module using procedural if statement
MuxModule always_module(
    .USE_ASSIGN(0),
    .a(a),
    .b(b),
    .sel_b1(sel_b1),
    .sel_b2(sel_b2),
    .out(out_always)
);

endmodule