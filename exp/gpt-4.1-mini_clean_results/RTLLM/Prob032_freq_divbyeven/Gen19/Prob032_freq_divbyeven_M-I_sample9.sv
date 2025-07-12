module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Assert NUM_DIV is even at elaboration time
    initial begin
        if (NUM_DIV < 2 || NUM_DIV % 2 != 0) begin
            $error("NUM_DIV parameter must be an even number >= 2. Given: %0d", NUM_DIV);
        end
    end

    // Calculate required counter width based on NUM_DIV
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);
    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == (NUM_DIV >> 1) - 1) begin
                clk_div <= ~clk_div;     // Toggle clk_div at half period
                cnt     <= cnt + 1;
            end else if (cnt == NUM_DIV - 1) begin
                cnt <= 0;               // Reset counter at full period
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule