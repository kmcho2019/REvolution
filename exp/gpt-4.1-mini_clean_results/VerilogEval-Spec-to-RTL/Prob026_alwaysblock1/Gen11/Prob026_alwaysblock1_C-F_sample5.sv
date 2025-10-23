module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment for the AND operation
    assign out_assign = a & b;

    // Combinational always block directly computes the AND from inputs
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule