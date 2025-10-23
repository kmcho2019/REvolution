module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire and_result;

    // Compute the AND once
    assign and_result = a & b;

    // Continuous assign output uses the wire directly
    assign out_assign = and_result;

    // Combinational always block assigns the registered output from the wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule