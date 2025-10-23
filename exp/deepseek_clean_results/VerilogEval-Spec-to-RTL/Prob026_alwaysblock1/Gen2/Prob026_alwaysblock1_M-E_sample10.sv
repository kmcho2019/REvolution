module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Assign implementation using NAND + NOT
    wire nand_result;
    assign nand_result = ~(a & b);
    assign out_assign = ~nand_result;

    // Always block implementation with intermediate steps
    always @(*) begin
        reg temp;
        temp = a & b;  // First compute AND
        out_alwaysblock = temp;  // Then assign to output
    end

endmodule