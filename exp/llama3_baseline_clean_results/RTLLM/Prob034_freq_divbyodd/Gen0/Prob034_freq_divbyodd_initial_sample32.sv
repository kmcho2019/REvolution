module freq_divbyodd (
    input clk,  // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Default odd divisor value

reg [3:0] cnt1;  // Counter for positive edge
reg [3:0] cnt2;  // Counter for negative edge
reg clk_div1;  // Clock divider for positive edge
reg clk_div2;  // Clock divider for negative edge
reg prev_clk;  // Previous clock value for edge detection

always @(*) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        prev_clk <= 0;
    end else begin
        // Detect rising edge
        if (clk && !prev_clk) begin
            cnt1 <= (cnt1 == (NUM_DIV - 1)) ? 0 : (cnt1 + 1);
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
            end
        end

        // Detect falling edge
        if (!clk && prev_clk) begin
            cnt2 <= (cnt2 == (NUM_DIV - 1)) ? 0 : (cnt2 + 1);
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
            end
        end

        prev_clk <= clk;
    end
end

assign clk_div = (clk_div1 || clk_div2);

endmodule