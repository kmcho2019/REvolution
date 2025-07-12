module TopModule(
    input  d,
    input  ena,
    output q
);

    reg q_reg;

    always @(d or ena) begin
        if (ena)
            q_reg = d;  // latch transparent when ena is high
        // else q_reg holds its value (latch behavior)
    end

    assign q = q_reg;

endmodule