module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Using assign statement for combinational AND
    assign out_assign = a & b;

    // Using always_comb block for combinational AND
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule