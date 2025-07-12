module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Direct continuous assignment for out_assign
    assign out_assign = a & b;

    // Combinational always block with explicit if-else for out_alwaysblock
    always @(*) begin
        if (a && b) begin
            out_alwaysblock = 1'b1;
        end else begin
            out_alwaysblock = 1'b0;
        end
    end

endmodule