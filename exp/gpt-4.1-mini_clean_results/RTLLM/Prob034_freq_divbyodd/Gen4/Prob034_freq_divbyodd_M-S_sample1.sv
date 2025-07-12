module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Odd divisor, default 5
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be odd and >= 3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd integer >= 3");
        end
    end

    localparam integer HALF = NUM_DIV >> 1; // floor(NUM_DIV / 2)
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;  // Toggle at end of count
            end else if (cnt == HALF - 1) begin
                cnt <= cnt + 1;
                clk_div <= ~clk_div;  // Toggle at half count
            end else begin
                cnt <= cnt + 1;
                clk_div <= clk_div;
            end
        end
    end

endmodule