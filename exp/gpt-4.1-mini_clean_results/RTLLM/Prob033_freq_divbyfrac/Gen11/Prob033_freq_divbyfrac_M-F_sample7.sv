module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] cnt;

    // Internal clocks with different duty cycles and phase shift
    reg clk_intA;
    reg clk_intB;

    // Counter: counts 0 to 6 repeatedly
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_intA: High for counts 0 to 3 (4 cycles), low for 4 to 6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intA <= 1'b0;
        else if (cnt <= 3'd3)
            clk_intA <= 1'b1;
        else
            clk_intA <= 1'b0;
    end

    // clk_intB: High for counts 5,6,0 (3 cycles), low for counts 1 to 4 (4 cycles)
    // This shifts clk_intB by 4 counts relative to clk_intA to create half-cycle phase shift
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else if ((cnt == 3'd5) || (cnt == 3'd6) || (cnt == 3'd0))
            clk_intB <= 1'b1;
        else
            clk_intB <= 1'b0;
    end

    // Final output clock: OR of clk_intA and clk_intB
    assign clk_div = clk_intA | clk_intB;

endmodule