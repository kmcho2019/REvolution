module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // Counter for positive edge
reg [2:0] cnt2;  // Counter for negative edge
reg clk_div1;    // Clock divider for positive edge
reg clk_div2;    // Clock divider for negative edge
reg prev_clk;    // Previous clock value

always @(*) begin
    // Calculate half of NUM_DIV, considering it's an odd number
    int half_div = (NUM_DIV - 1) / 2;
    
    // Initialize counter values and clock divider outputs
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end
    else begin
        // Detect rising edge
        if (clk && !prev_clk) begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == half_div) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end
        end
        
        // Detect falling edge
        if (!clk && prev_clk) begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == half_div) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end
        end
        
        // Update previous clock value
        prev_clk <= clk;
    end
end

// Derive final divided clock output by OR-ing clk_div1 and clk_div2
assign clk_div = clk_div1 | clk_div2;

endmodule