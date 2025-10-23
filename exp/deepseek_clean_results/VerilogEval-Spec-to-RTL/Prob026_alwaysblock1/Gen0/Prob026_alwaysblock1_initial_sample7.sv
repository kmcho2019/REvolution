module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Implementation using continuous assignment
    assign out_assign = a & b;

    // Implementation using combinational always block
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule