module TopModule (
    input wire clk,
    input wire d,
    output reg q
);

    reg d_pos, d_neg;
    reg clk_delayed;

    // Create a delayed and inverted clock internally
    reg clk_inv_stage1;
    always @(posedge clk) begin
        clk_inv_stage1 <= ~clk;
    end
    always @(posedge clk) begin
        clk_delayed <= clk_inv_stage1;
    end

    // Sample 'd' on rising edge of clk (posedge)
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Sample 'd' on rising edge of delayed inverted clock (approx falling edge of clk)
    always @(posedge clk_delayed) begin
        d_neg <= d;
    end

    // Combine both samples on rising clk edge
    always @(posedge clk) begin
        // Latch output from either posedge or negedge sampling,
        // prioritizing the most recent sample (d_neg when available)
        q <= clk ? d_pos : d_neg; 
        // Note: since this is running at posedge clk, the ternary reduces to q <= d_pos.
        // To include negedge samples, we latch q <= d_neg at the posedge of clk_delayed.
    end

    // Update q on delayed clock edge with d_neg to reflect negedge sampling
    always @(posedge clk_delayed) begin
        q <= d_neg;
    end

endmodule