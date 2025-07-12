module freq_divbyodd(
    input clk,       // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Divided clock output
);

parameter NUM_DIV = 5;  // Default divisor value

reg [1:0] cnt1;         // Counter for rising edge
reg [1:0] cnt2;         // Counter for falling edge
reg clk_div1;           // Divided clock for positive edge
reg clk_div2;           // Divided clock for negative edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset logic
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else if (cnt1 == (NUM_DIV / 2) - 1) begin  // Toggle clk_div1 at half of NUM_DIV
        clk_div1 <= ~clk_div1;
        cnt1 <= 0;
    end else begin
        cnt1 <= cnt1 + 1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset logic
        clk_div2 <= 0;
    end else if (cnt2 == (NUM_DIV / 2) - 1) begin  // Toggle clk_div2 at half of NUM_DIV
        clk_div2 <= ~clk_div2;
        cnt2 <= 0;
    end else begin
        cnt2 <= cnt2 + 1;
    end
end

always @(*) begin  // Combine divided clocks for both edges
    clk_div = clk_div1 | clk_div2;
end

endmodule