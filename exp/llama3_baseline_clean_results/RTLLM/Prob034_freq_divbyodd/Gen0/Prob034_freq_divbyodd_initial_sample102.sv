module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input clk,         // Input clock signal
    input rst_n,        // Active low reset signal
    output reg clk_div  // Divided clock output
);

reg [2:0] cnt1;  // Counter for rising edge
reg [2:0] cnt2;  // Counter for falling edge
reg clk_div1;    // Clock divider for positive edge
reg clk_div2;    // Clock divider for negative edge
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
        // Detect rising edge
        if (clk &&!prev_clk) begin
            if (cnt1 == (NUM_DIV / 2)) begin
                // Toggle clk_div1 when cnt1 reaches half of NUM_DIV
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end else begin
                // Increment cnt1 on rising edge
                cnt1 <= cnt1 + 1;
            end
        end
        
        // Detect falling edge
        if (!clk && prev_clk) begin
            if (cnt2 == (NUM_DIV / 2)) begin
                // Toggle clk_div2 when cnt2 reaches half of NUM_DIV
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end else begin
                // Increment cnt2 on falling edge
                cnt2 <= cnt2 + 1;
            end
        end
        
        // Update previous clock value
        prev_clk <= clk;
    end
end

// Derive final divided clock output by logically OR-ing clk_div1 and clk_div2
assign clk_div = clk_div1 | clk_div2;

endmodule