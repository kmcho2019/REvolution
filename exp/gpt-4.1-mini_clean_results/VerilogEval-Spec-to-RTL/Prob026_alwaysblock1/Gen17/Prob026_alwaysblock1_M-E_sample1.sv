module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Assign output by ANDing the concatenated inputs (a,b) with a mask of 2'b11
    assign out_assign = ({a,b} & 2'b11) == 2'b11 ? 1'b1 : 1'b0;

    always @(*) begin
        // Use an if-else statement to explicitly set output based on AND condition
        if (a & b)
            out_alwaysblock = 1'b1;
        else
            out_alwaysblock = 1'b0;
    end

endmodule