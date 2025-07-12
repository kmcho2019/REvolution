module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Direct assignment implementation
    assign out_assign = a & b;

    // Instantiate a separate AND module for the always block
    wire and_result;
    AND_Gate and_inst (
        .a(a),
        .b(b),
        .out(and_result)
    );

    // Procedural assignment of the module output
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule

// Separate AND gate module
module AND_Gate (
    input a,
    input b,
    output reg out
);
    always @(*) begin
        out = a & b;
    end
endmodule