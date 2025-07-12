module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Check NUM_DIV is odd at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam MID_POINT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt     <= 0;
                clk_div <= ~clk_div;       // Toggle at full count wrap
            end else begin
                cnt <= cnt + 1;
                if (cnt == MID_POINT) begin
                    clk_div <= ~clk_div;   // Toggle at midpoint for 50% duty cycle
                end
            end
        end
    end

endmodule