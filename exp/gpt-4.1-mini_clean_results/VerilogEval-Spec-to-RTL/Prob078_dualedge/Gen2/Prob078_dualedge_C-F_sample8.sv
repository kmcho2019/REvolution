module TopModule(
    input clk,
    input d,
    output reg q
);

    reg q_pos, q_neg;
    reg q_reg;

    // Capture input d on rising edge
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Capture input d on falling edge
    always @(negedge clk) begin
        q_neg <= d;
    end

    // Register output on rising edge to reduce glitches and improve timing
    always @(posedge clk) begin
        if (clk)
            q_reg <= q_pos;
        else
            q_reg <= q_neg;
    end

    // Assign registered output to module output
    always @(*) begin
        q = q_reg;
    end

endmodule