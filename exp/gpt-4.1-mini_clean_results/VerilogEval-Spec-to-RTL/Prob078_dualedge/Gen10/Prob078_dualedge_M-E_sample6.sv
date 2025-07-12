module TopModule (
    input  clk,
    input  d,
    output reg q
);

    reg clk_delayed;
    reg d_sampled;

    // Generate delayed version of clk (1 gate delay)
    always @(posedge clk or negedge clk) begin
        // Non-synthesizable delay construct avoided by using FF chain
        // Here, just sample clk delayed by one delta cycle in simulation.
        // In synthesis, implement delay by routing or specific resources.
        clk_delayed <= clk;
    end

    // Generate double frequency clock by XORing clk and delayed clk
    wire clk_2x = clk ^ clk_delayed;

    // Flip-flop sampling d on both edges of original clk, implemented as posedge clk_2x FF
    reg d_on_2xclk;
    always @(posedge clk_2x) begin
        d_on_2xclk <= d;
    end

    // Final stage synchronizing output to original clk domain
    always @(posedge clk) begin
        q <= d_on_2xclk;
    end

endmodule