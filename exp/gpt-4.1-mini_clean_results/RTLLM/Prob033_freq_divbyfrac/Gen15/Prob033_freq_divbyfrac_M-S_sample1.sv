module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // counts for 3.5 division in half-cycles

    // Counter from 0 to 6 (7 states)
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Main divided clock level: high for counts 0 to 3, low for 4 to 6
    wire clk_div_main = (cnt <= 3'd3);

    // Register clk_div_main sampled at negedge clk to create half-cycle shifted version
    reg clk_div_delayed;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_delayed <= 1'b0;
        else
            clk_div_delayed <= clk_div_main;
    end

    // Final output is OR of original and delayed clocks to fill the half-cycle gaps
    assign clk_div = clk_div_main | clk_div_delayed;

endmodule