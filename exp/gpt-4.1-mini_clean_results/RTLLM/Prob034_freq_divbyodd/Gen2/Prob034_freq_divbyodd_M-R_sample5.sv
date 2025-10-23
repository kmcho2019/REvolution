module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Validate that NUM_DIV is an odd number >= 3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) >> 1;  // (NUM_DIV-1)/2

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    reg clk_div1;
    reg clk_div2;

    // Positive edge logic: toggle clk_div1 at HALF_COUNT, then increment counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div1 <= 0;
        end else begin
            // Toggle clk_div1 when counter reaches HALF_COUNT
            if (cnt_pos == HALF_COUNT) begin
                clk_div1 <= ~clk_div1;
            end

            // Increment counter or reset
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
            end else begin
                cnt_pos <= cnt_pos + 1;
            end
        end
    end

    // Negative edge logic: toggle clk_div2 at HALF_COUNT, then increment counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div2 <= 0;
        end else begin
            // Toggle clk_div2 when counter reaches HALF_COUNT
            if (cnt_neg == HALF_COUNT) begin
                clk_div2 <= ~clk_div2;
            end

            // Increment counter or reset
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
            end else begin
                cnt_neg <= cnt_neg + 1;
            end
        end
    end

    // Output divided clock is OR of clk_div1 and clk_div2 to form ~50% duty cycle odd divide clock
    assign clk_div = clk_div1 | clk_div2;

endmodule