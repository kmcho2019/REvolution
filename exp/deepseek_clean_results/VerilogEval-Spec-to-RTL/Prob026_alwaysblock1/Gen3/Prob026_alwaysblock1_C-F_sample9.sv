module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Direct assign implementation (simplest form)
    assign out_assign = a & b;

    // Combinational always block with direct output assignment
    always @(*) begin
        out_alwaysblock = a & b;
    end

endmodule