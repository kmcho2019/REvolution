module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
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
    reg phase;  // Toggles every HALF_DIV counts, controls clk_div phase

    // Counter and phase management on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            phase   <= 1'b0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt   <= 0;
                phase <= ~phase;       // Toggle phase every full cycle
            end else begin
                cnt <= cnt + 1;
            end

            // Generate clk_div with a high pulse of length HALF_DIV + 1 counts per phase
            // When phase=0, clk_div = 1 for cnt in [0, HALF_DIV], else 0
            // When phase=1, clk_div = 1 for cnt in [0, HALF_DIV], else 0
            // This yields a duty cycle close to 50% for odd NUM_DIV
            if (cnt <= HALF_DIV)
                clk_div <= phase ? 1'b0 : 1'b1;  // For phase=0, clk_div high first half
            else
                clk_div <= phase ? 1'b1 : 1'b0;  // For phase=1, clk_div high second half
        end
    end

endmodule