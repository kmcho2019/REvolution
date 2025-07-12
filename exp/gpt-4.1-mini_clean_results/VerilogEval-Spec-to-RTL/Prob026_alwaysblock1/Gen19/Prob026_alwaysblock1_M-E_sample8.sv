module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Continuous assignment for the AND function
    assign out_assign = a & b;

    // Combinational always block with non-blocking assignment for AND function
    always @(*) begin
        out_alwaysblock <= a & b;
    end

endmodule