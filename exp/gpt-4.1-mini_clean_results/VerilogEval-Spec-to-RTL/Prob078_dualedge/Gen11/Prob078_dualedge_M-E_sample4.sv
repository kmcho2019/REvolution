module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg q_pos;    // sample of d at positive edge clk
    reg q_neg;    // sample of d at positive edge of inverted clk (~clk)
    
    // Flip-flop that samples d at positive edge of clk (rising edge)
    always @(posedge clk) begin
        q_pos <= d;
    end

    // Flip-flop that samples d at positive edge of inverted clk (falling edge of clk)
    always @(posedge ~clk) begin
        q_neg <= d;
    end

    // State update logic: on positive edge of clk, update output q
    // Logic: if q_pos and q_neg differ, output the most recent sampled data
    // The most recent is q_neg if clk just fell, but since we update only at posedge clk,
    // choose the q_neg value as well to reflect negative-edge sample.
    // We combine q_pos and q_neg so output updates on both edges effectively.
    always @(posedge clk) begin
        // If negative edge sample differs, output the negative edge sample
        // else output positive edge sample
        if (q_pos != q_neg)
            q <= q_neg;
        else
            q <= q_pos;
    end

endmodule