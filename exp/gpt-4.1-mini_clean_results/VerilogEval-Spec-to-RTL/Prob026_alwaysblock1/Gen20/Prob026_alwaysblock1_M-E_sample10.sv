module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment directly implements AND gate
    assign out_assign = a & b;

    // Combinational always block with if-else structure
    always @(*) begin
        if (a & b)
            out_alwaysblock = 1'b1;
        else
            out_alwaysblock = 1'b0;
    end

endmodule