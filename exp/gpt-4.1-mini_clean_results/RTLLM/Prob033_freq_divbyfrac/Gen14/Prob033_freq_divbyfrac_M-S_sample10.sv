module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] cnt;

    // Count 0 to 6 on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == 3'd6)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_intA high for counts 0-3 (4 cycles)
    wire clk_intA = (cnt <= 3'd3);

    // clk_intB delayed by half cycle using falling edge register of clk_intA
    reg clk_intB;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_intB <= 1'b0;
        else
            clk_intB <= clk_intA;
    end

    // Output is OR of clk_intA and clk_intB for fractional division by 3.5
    assign clk_div = clk_intA | clk_intB;

endmodule