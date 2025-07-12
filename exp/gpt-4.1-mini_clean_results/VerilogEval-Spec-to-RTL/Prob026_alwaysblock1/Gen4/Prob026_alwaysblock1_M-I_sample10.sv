module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Drive out_assign directly using assign
    assign out_assign = a & b;

    // Drive out_alwaysblock using a combinational always block with direct expression
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule