module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

// Parameterizable AND gate module
module param_and_gate #(
    parameter use_assign = 1
) (
    input a,
    input b,
    output out
);

    reg out_reg;

    if (use_assign) begin
        // Using assign statement for continuous assignment
        assign out = a & b;
    end else begin
        // Using always block for combinational logic
        always @(*) begin
            out_reg = a & b;
            out = out_reg;
        end
    end

endmodule

// Instantiate the param_and_gate module for out_assign
param_and_gate #(.use_assign(1)) assign_and (
    .a(a),
    .b(b),
    .out(out_assign)
);

// Instantiate the param_and_gate module for out_alwaysblock
param_and_gate #(.use_assign(0)) always_and (
    .a(a),
    .b(b),
    .out(out_alwaysblock)
);

endmodule