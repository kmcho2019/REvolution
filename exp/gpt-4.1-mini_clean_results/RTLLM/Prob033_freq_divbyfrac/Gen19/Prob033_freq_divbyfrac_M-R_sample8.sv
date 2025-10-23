module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    localparam integer MUL2_DIV_CLK = 7;  // total half cycles in one full period (7 half cycles = 3.5 clk periods)

    reg [2:0] count;       // counter for half cycles: 0..6
    reg       clk_divA;    // intermediate clock A
    reg       clk_divB;    // intermediate clock B (phase shifted)

    // Half cycle counter: increments from 0 to 6 then wraps
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == (MUL2_DIV_CLK - 1))
            count <= 3'd0;
        else
            count <= count + 1'b1;
    end

    // clk_divA toggles at count 0 and 4 (half cycle counts)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_divA <= 1'b0;
        else if (count == 3'd0 || count == 3'd4)
            clk_divA <= ~clk_divA;
    end

    // clk_divB toggles at count 3 and count 0 (phase shifted by half cycle)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_divB <= 1'b0;
        else if (count == 3'd3 || count == 3'd0)
            clk_divB <= ~clk_divB;
    end

    // Final fractional divided clock is the OR of the two phase-shifted intermediate clocks
    assign clk_div = clk_divA | clk_divB;

endmodule