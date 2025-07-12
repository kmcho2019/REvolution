module TopModule(
    input a,
    input b,
    output out_assign,
    output reg out_alwaysblock
);

    // Implementation using continuous assignment (assign statement)
    assign out_assign = a & b;

    // Implementation using combinational always block
    always @(*) begin
        // Blocking assignment for combinational logic
        out_alwaysblock = a & b;
    end

endmodule