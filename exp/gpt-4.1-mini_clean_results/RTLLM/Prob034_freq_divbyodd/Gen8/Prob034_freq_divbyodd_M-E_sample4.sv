module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameter validation at elaboration time
    initial begin
        if (NUM_DIV < 3) begin
            $error("NUM_DIV must be >= 3");
        end
        if ((NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number");
        end
    end

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for rising and falling edges
    reg [CNT_WIDTH-1:0] cnt_rise;
    reg [CNT_WIDTH-1:0] cnt_fall;

    // Divided clocks toggled on counters
    reg clk_div1;
    reg clk_div2;

    // Half count for toggle comparison
    localparam HALF_COUNT = (NUM_DIV - 1) / 2;

    // Rising edge counter and toggle logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rise <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt_rise == NUM_DIV - 1) begin
                cnt_rise <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt_rise <= cnt_rise + 1;
                // Toggle clk_div1 at half count
                if (cnt_rise == HALF_COUNT)
                    clk_div1 <= ~clk_div1;
            end
        end
    end

    // Falling edge counter and toggle logic
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt_fall == NUM_DIV - 1) begin
                cnt_fall <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt_fall <= cnt_fall + 1;
                // Toggle clk_div2 at half count
                if (cnt_fall == HALF_COUNT)
                    clk_div2 <= ~clk_div2;
            end
        end
    end

    // Output is OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule