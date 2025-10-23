module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF = (NUM_DIV - 1) / 2;

    // Counter width enough to count up to NUM_DIV-1
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end

            // Toggle clk_div on count 0 and on count HALF
            if (cnt == 0 || cnt == HALF) begin
                clk_div <= ~clk_div;
            end
        end
    end

endmodule