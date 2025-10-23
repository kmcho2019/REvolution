module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Single internal wire computing AND once
    wire and_result;
    assign and_result = a & b;

    // Continuous assign for out_assign
    assign out_assign = and_result;

    // Combinational always block for out_alwaysblock
    always @(*) begin
        out_alwaysblock = and_result;
    end

endmodule