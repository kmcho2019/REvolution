module TopModule(
    input  d,
    input  ena,
    output q
);
    reg q_reg;

    // Continuous assignment to output
    assign q = q_reg;

    // Latch behavior via combinational always block with blocking assignment
    always @(*) begin
        if (ena)
            q_reg = d;  // latch transparent when ena is high
        else
            q_reg = q_reg; // hold previous value, inferred by feedback
    end
endmodule