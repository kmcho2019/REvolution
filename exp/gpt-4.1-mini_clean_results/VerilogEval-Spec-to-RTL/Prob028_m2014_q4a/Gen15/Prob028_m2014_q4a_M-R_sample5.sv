module TopModule(
    input  d,
    input  ena,
    output q
);
    // Declare q as reg internally to hold state (since output is 1 bit)
    reg q_reg;

    // Continuous assignment of output port to internal register
    assign q = q_reg;

    always @(*) begin
        if (ena)
            q_reg = d;
        else
            q_reg = q_reg; // hold previous value - latch inferred
    end
endmodule