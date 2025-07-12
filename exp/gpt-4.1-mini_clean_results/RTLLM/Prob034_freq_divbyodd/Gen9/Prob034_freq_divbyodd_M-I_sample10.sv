module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2; // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // Single edge synchronous counter and clk_div generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 1'b0;
        end else begin
            // Counter cycles from 0 to NUM_DIV-1
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end

            // Generate clk_div:
            // High when cnt <= HALF_DIV, else low
            // This yields a duty cycle of (HALF_DIV+1)/NUM_DIV, near 50% for odd divisors
            if (cnt <= HALF_DIV)
                clk_div <= 1'b1;
            else
                clk_div <= 1'b0;
        end
    end

endmodule