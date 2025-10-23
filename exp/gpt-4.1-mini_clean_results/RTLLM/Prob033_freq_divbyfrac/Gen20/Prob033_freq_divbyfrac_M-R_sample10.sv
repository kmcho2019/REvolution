module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    localparam integer MUL2_DIV_CLK = 7;  // 7 half cycles = 3.5 clk cycles

    reg [2:0] count;      // Counts from 0 to 6

    // Synchronous counter incrementing every posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == (MUL2_DIV_CLK - 1))
            count <= 3'd0;
        else
            count <= count + 1'b1;
    end

    // Combinational logic to define intermediate clocks based on count
    // clk_divA: High for counts 0 to 3 (4 half cycles), Low for 4 to 6 (3 half cycles)
    // clk_divB: High for counts 3 to 6 (4 half cycles), Low for 0 to 2 (3 half cycles)
    wire clk_divA_next = (count <= 3'd3);          // counts 0..3 high
    wire clk_divB_next = (count >= 3'd3);          // counts 3..6 high

    // Register intermediate clocks to synchronize and avoid glitches
    reg clk_divA_reg, clk_divB_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_divA_reg <= 1'b0;
            clk_divB_reg <= 1'b0;
        end else begin
            clk_divA_reg <= clk_divA_next;
            clk_divB_reg <= clk_divB_next;
        end
    end

    // Final fractional divided clock: OR of intermediate clocks
    assign clk_div = clk_divA_reg | clk_divB_reg;

endmodule