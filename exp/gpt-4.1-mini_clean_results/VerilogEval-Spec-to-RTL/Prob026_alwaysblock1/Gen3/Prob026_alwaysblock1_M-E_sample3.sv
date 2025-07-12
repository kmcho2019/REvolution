module TopModule(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    wire a_buf, b_buf;
    reg  a_reg, b_reg;

    // Buffer inputs in wires
    assign a_buf = a;
    assign b_buf = b;

    // Buffer inputs in registers (combinational style)
    always @(*) begin
        a_reg = a_buf;
        b_reg = b_buf;
    end

    // AND using assign statement on buffered wires
    assign out_assign = a_buf & b_buf;

    // AND using always block on buffered registers
    always @(*) begin
        out_alwaysblock = a_reg & b_reg;
    end

endmodule