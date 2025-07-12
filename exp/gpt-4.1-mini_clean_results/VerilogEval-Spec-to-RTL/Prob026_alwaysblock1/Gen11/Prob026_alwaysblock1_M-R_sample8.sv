module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Intermediate wire holding the AND result
    wire and_result;
    assign and_result = a & b;

    // Assign output directly from the intermediate wire
    assign out_assign = and_result;

    // Combinational always block driven by the intermediate wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule