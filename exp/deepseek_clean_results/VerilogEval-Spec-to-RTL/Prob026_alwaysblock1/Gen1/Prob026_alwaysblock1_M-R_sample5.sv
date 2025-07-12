module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Implementation using assign statement (unchanged)
    assign out_assign = a & b;

    // Implementation using always block (now with correct reg declaration)
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule