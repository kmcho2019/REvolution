module TopModule (
    input wire clk,
    input wire d,
    output wire q
);

    reg d_pos;      // Data captured at posedge clk
    reg d_neg;      // Data captured at negedge clk (using clk_n)

    wire clk_n = ~clk;

    // Flip-flop capturing d at posedge clk
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Flip-flop capturing d_pos at posedge clk_n (negedge of clk)
    always @(posedge clk_n) begin
        d_neg <= d_pos;
    end

    // Transparent latch controlled by clk level:
    // When clk=1, output follows d_pos; when clk=0, output follows d_neg
    reg q_reg;
    always @(*) begin
        if (clk)
            q_reg = d_pos;
        else
            q_reg = d_neg;
    end

    assign q = q_reg;

endmodule