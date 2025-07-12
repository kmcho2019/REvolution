module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer COUNT_MAX = 7; // 3.5 * 2

    reg [2:0] cnt;

    // Synchronous counter 0..6
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == COUNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // div_clk_a high for counts 0..3 (4 cycles)
    wire div_clk_a = (cnt < 4);

    // Calculate phase-shifted count for div_clk_b by offsetting cnt by 4 modulo 7
    wire [2:0] cnt_shifted = (cnt + 3'd4 >= COUNT_MAX) ? (cnt + 3'd4 - COUNT_MAX) : (cnt + 3'd4);

    // div_clk_b high for counts 0..3 (4 cycles) of the shifted count
    wire div_clk_b = (cnt_shifted < 4);

    // Output clock is OR of two half-cycle shifted signals
    assign clk_div = div_clk_a | div_clk_b;

endmodule