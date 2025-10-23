module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment for out_assign (direct AND)
    assign out_assign = a & b;

    // Intermediate wire for AND result
    wire and_result;
    assign and_result = a & b;

    // Combinational always block that assigns out_alwaysblock from intermediate wire
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule