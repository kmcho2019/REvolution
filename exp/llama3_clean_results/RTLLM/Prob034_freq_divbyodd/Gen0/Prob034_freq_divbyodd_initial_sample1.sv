module freq_divbyodd (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5; // Default odd divisor value

reg [1:0] cnt1; // Counter for rising edge
reg [1:0] cnt2; // Counter for falling edge
reg clk_div1; // Clock divider for positive edge
reg clk_div2; // Clock divider for negative edge

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV / 2) - 1) begin // Toggle clk_div1 at half of NUM_DIV
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
        
        if (~clk) begin // For negative edge
            if (cnt2 == (NUM_DIV / 2) - 1) begin // Toggle clk_div2 at half of NUM_DIV
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end else begin
            cnt2 <= 0; // Reset cnt2 for positive edge
        end
    end
end

always @ (*) begin
    clk_div = clk_div1 | clk_div2; // Derive final divided clock output
end

endmodule