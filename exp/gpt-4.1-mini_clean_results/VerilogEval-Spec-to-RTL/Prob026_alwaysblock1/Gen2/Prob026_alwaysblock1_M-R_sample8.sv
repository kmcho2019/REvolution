module TopModule(
    input  a,
    input  b,
    output reg out_assign,
    output out_alwaysblock
);

    // Combinational always block to assign out_assign (AND)
    always @(*) begin
        out_assign = a & b;
    end

    // Continuous assignment for out_alwaysblock (direct AND)
    assign out_alwaysblock = a & b;

endmodule