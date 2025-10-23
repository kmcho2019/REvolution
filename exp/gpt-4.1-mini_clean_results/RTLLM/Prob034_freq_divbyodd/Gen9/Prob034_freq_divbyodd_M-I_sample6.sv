module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF = (NUM_DIV - 1) / 2;
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt_rise;
    reg [COUNTER_WIDTH-1:0] cnt_fall;

    reg clk_div1;
    reg clk_div2;

    // Rising edge counter and clk_div1 toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_rise <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt_rise == NUM_DIV - 1) begin
                cnt_rise <= 0;
                clk_div1 <= ~clk_div1;    // Toggle at end of full count
            end else if (cnt_rise == HALF) begin
                cnt_rise <= cnt_rise + 1;
                clk_div1 <= ~clk_div1;    // Toggle at half period
            end else begin
                cnt_rise <= cnt_rise + 1;
            end
        end
    end

    // Falling edge counter and clk_div2 toggling
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt_fall == NUM_DIV - 1) begin
                cnt_fall <= 0;
                clk_div2 <= ~clk_div2;    // Toggle at end of full count
            end else if (cnt_fall == HALF) begin
                cnt_fall <= cnt_fall + 1;
                clk_div2 <= ~clk_div2;    // Toggle at half period
            end else begin
                cnt_fall <= cnt_fall + 1;
            end
        end
    end

    // Final divided clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule