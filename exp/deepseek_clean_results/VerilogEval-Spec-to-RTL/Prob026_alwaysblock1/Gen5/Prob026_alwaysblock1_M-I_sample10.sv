module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // Simple AND implementation using assign
    assign out_assign = a & b;

    // Simple AND implementation using always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule