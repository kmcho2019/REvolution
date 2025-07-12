module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Direct assign statement for AND operation
    assign out_assign = a & b;

    // Combinational always block using if-else for AND operation
    always @(*) begin
        if (a == 1'b1 && b == 1'b1)
            out_alwaysblock = 1'b1;
        else
            out_alwaysblock = 1'b0;
    end

endmodule