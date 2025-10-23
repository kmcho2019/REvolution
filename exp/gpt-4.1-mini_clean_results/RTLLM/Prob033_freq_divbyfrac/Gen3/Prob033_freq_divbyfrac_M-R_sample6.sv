module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV_TOTAL = 7; // 2 * division factor (3.5*2)

    reg [2:0] count;
    // Intermediate clocks
    reg clk_intA;    // High for 4 counts on posedge domain
    reg clk_intB;    // High for 3 counts on negedge domain (phase shifted)

    // Generate counter on posedge clk, synchronous reset
    always @(posedge clk) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_TOTAL-1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_intA: high for count in [0..3], low otherwise, updated on posedge clk
    always @(posedge clk) begin
        if (!rst_n)
            clk_intA <= 1'b0;
        else
            clk_intA <= (count < 4);
    end

    // To generate clk_intB, first create enable on posedge clk, then register it on negedge clk
    reg clk_intB_next;
    reg clk_intB_reg;

    always @(posedge clk) begin
        if (!rst_n)
            clk_intB_next <= 1'b0;
        else
            clk_intB_next <= (count < 3);
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB_reg <= 1'b0;
        else
            clk_intB_reg <= clk_intB_next;
    end

    assign clk_intB = clk_intB_reg;

    // Final fractional divided clock is OR of phase-shifted clk_intA and clk_intB
    assign clk_div = clk_intA | clk_intB;

endmodule