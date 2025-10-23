module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment directly with AND expression
    assign out_assign = a & b;

    // Combinational always block directly computes the AND
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule