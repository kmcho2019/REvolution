module TopModule (
    input clk,
    input d,
    output reg q
);
    // Generate delayed clock (1-gate delay)
    wire clk_delayed;
    // Using a simple buffer for delay (synthesis tool may implement as small delay element)
    // For simulation, use #1 delay
    reg clk_del_reg;
    always @(posedge clk or negedge clk) begin
        clk_del_reg <= clk;
    end
    assign clk_delayed = clk_del_reg;

    // Generate clk_x2 by XORing clk and delayed clk
    wire clk_x2 = clk ^ clk_delayed;

    // Single positive-edge FF triggered by clk_x2 pulse (short pulse on both clk edges)
    reg q_ff;
    always @(posedge clk_x2) begin
        q_ff <= d;
    end

    // Optional: synchronize q_ff to original clk domain with a latch to avoid glitches
    // Latch transparent when clk=1, holding q_ff value, giving stable q output aligned with clk
    always @(clk or q_ff) begin
        if (clk)
            q <= q_ff;
        // else hold previous q
    end

endmodule