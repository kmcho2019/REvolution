module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Single counter running on positive clock edge
    reg [CNT_WIDTH-1:0] cnt;

    // Delayed version of counter (1 clk cycle delayed)
    reg [CNT_WIDTH-1:0] cnt_dly;

    // Asynchronous reset for counters
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            cnt_dly <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;
            cnt_dly <= cnt;
        end
    end

    // clk_div1 is high when cnt in [0, HALF_DIV-1], low otherwise
    // Using a combinational assign for clk_div1 to reduce registers
    wire clk_div1 = (cnt <= HALF_DIV - 1);

    // clk_div2 is high when delayed cnt_dly in [0, HALF_DIV-1], low otherwise
    wire clk_div2 = (cnt_dly <= HALF_DIV - 1);

    // Final clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule