module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign using direct AND expression
    assign out_assign = a & b;

    // Combinational always block using direct AND expression
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule