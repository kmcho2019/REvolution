module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Simple AND using assign statement
    assign out_assign = a & b;

    // Simple AND using always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule