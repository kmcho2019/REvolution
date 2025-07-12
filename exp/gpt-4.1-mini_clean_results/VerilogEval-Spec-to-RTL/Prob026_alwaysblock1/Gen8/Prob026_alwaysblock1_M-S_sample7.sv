module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment implementing AND directly
    assign out_assign = a & b;

    // Combinational always block directly using inputs for AND
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule