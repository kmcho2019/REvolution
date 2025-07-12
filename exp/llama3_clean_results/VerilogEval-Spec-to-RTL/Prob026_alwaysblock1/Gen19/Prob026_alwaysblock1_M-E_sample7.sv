// Parameterizable module for AND gate implementation
module AndGateParam(
    input  mode, // 0 for assign, 1 for always block
    input  a,
    input  b,
    output out,
    output mode_out // Output to indicate the current mode
);

reg out_always;

always @(*) begin
    if (mode == 1'b1) begin
        out_always = a & b;
    end
end

assign mode_out = mode;
assign out = (mode == 1'b0) ? (a & b) : out_always;

endmodule

// TopModule that instantiates the parameterizable AndGateParam
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

AndGateParam u_and_assign(
    .mode(1'b0), // Configure for assign statement
    .a(a),
    .b(b),
    .out(out_assign),
    .mode_out()
);

AndGateParam u_and_always(
    .mode(1'b1), // Configure for combinational always block
    .a(a),
    .b(b),
    .out(out_alwaysblock),
    .mode_out()
);

endmodule