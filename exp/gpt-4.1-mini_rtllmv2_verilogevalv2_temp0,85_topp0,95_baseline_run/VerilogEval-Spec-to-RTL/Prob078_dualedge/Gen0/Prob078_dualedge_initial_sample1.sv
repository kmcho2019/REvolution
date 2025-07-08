module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg q_pos;
    reg q_neg;

    // Sample d on the positive edge of clk
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Sample d on the negative edge of clk
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Multiplex between q_pos and q_neg based on clk
    always @(*) begin
        if (clk)
            q = q_pos;
        else
            q = q_neg;
    end

endmodule