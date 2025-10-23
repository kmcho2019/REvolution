module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd, but is %0d", NUM_DIV);
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2;
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
                clk_div <= ~clk_div;  // Toggle at end of full count
            end else begin
                cnt <= cnt + 1;
                if (cnt == HALF_COUNT) begin
                    clk_div <= ~clk_div;  // Toggle at midpoint count
                end
            end
        end
    end

endmodule