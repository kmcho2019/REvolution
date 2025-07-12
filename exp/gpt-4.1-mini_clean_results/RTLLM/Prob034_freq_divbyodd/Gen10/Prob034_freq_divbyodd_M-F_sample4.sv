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

    reg [COUNTER_WIDTH-1:0] count;
    reg clk_div1;
    reg clk_div2;

    // Counter increments on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            clk_div1 <= 0;
        end else begin
            if (count == NUM_DIV - 1) begin
                count <= 0;
                clk_div1 <= ~clk_div1; // Toggle at end of count
            end else begin
                count <= count + 1;
            end
        end
    end

    // Toggle clk_div2 on falling edge of clk when count == HALF
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 0;
        end else begin
            if (count == HALF) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combine two toggles for output clock
    assign clk_div = clk_div1 | clk_div2;

endmodule