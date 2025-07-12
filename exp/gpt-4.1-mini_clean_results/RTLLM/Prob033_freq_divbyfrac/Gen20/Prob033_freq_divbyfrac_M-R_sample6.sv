module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    localparam integer MUL2_DIV_CLK = 7;  // total half cycles in one full period (7 half cycles = 3.5 clk periods)

    reg [2:0] count;         // 3-bit counter 0..6
    reg       clk_divA;      // intermediate clock A
    reg       clk_divB;      // intermediate clock B (phase shifted)

    // Counter incremented every clock cycle, wrapping at 6->0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == (MUL2_DIV_CLK - 1))
            count <= 3'd0;
        else
            count <= count + 1'b1;
    end

    // Generate clk_divA pattern: high for counts 0..3 (4 half cycles), low for 4..6 (3 half cycles)
    // Registered to avoid glitches
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_divA <= 1'b0;
        else
            clk_divA <= (count <= 3'd3);
    end

    // Generate clk_divB as clk_divA delayed by one count (half clock cycle phase shift)
    // This means for clk_divB high counts: (count+1) % 7 <= 3
    wire [2:0] delayed_count = (count == (MUL2_DIV_CLK - 1)) ? 3'd0 : count + 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_divB <= 1'b0;
        else
            clk_divB <= (delayed_count <= 3'd3);
    end

    // Final output is OR of clk_divA and clk_divB to get stable 3.5 division and good duty cycle
    assign clk_div = clk_divA | clk_divB;

endmodule