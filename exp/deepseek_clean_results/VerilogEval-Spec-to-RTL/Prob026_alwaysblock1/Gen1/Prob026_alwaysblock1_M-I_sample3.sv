module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Implementation using assign statement (optimal for simple combinational logic)
    assign out_assign = a & b;

    // Corrected implementation using always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule