// Parameterized module for AND gate implementation
module AndGate #(
    parameter USE_ASSIGN = 1 // 1 for assign statement, 0 for always block
)(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Conditional instantiation based on USE_ASSIGN parameter
generate
    if (USE_ASSIGN) begin
        assign out_assign = a & b;
        assign out_alwaysblock = a & b; // For consistency, also assign to out_alwaysblock
        $display("Using assign statement for AND gate implementation.");
    end else begin
        always @(*) begin
            out_alwaysblock = a & b;
        end
        assign out_assign = out_alwaysblock; // For consistency, also assign to out_assign
        $display("Using combinational always block for AND gate implementation.");
    end
endgenerate

endmodule

// TopModule that instantiates the parameterized AndGate
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);
    
AndGate #(.USE_ASSIGN(1)) u_and_assign(
    .a(a),
    .b(b),
    .out_assign(out_assign),
    .out_alwaysblock(out_alwaysblock)
);

endmodule