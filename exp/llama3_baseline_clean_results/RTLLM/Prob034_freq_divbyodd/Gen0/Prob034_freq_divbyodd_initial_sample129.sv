module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input  clk,         // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Divided clock output
);

reg [31:0] cnt1;  // Counter for rising edges
reg [31:0] cnt2;  // Counter for falling edges
reg clk_div1;     // Divided clock for positive edges
reg clk_div2;     // Divided clock for negative edges
reg prev_clk;     // Previous clock value for edge detection

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize counters and clock dividers on reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        // Detect rising and falling edges
        if (clk && !prev_clk) begin
            // Rising edge
            if (cnt1 == (NUM_DIV - 1) / 2) begin
                clk_div1 <= ~clk_div1;  // Toggle clk_div1
            end
            cnt1 <= cnt1 + 1;
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end
        end else if (!clk && prev_clk) begin
            // Falling edge
            if (cnt2 == (NUM_DIV - 1) / 2) begin
                clk_div2 <= ~clk_div2;  // Toggle clk_div2
            end
            cnt2 <= cnt2 + 1;
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end
        end
        prev_clk <= clk;
    end
end

// Derive the final divided clock output by OR-ing clk_div1 and clk_div2
assign clk_div = clk_div1 || clk_div2;

endmodule