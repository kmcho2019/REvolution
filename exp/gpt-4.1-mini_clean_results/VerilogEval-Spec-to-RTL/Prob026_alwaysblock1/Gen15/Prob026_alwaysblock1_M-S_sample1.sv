module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assign output with direct AND expression
    assign out_assign = a & b;

    // Combinational always block output with direct AND expression
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule