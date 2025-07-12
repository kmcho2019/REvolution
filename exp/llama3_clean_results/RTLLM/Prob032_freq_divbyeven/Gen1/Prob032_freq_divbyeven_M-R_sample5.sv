module freq_diveven #(
    parameter NUM_DIV = 10  // Even number specifying the division factor
)(
    input  clk,            // Input clock signal
    input  rst_n,          // Active-low reset signal
    output reg  clk_div    // Divided clock output signal
);

reg [3:0] cnt;             // 4-bit counter to track clock cycles

// Continuous assignment to update counter value
assign cnt = (~rst_n)? 4'b0 : (cnt == (NUM_DIV / 2 - 1))? 4'b0 : (cnt + 1'b1);

// Separate always block to toggle divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin      // Active-low reset
        clk_div <= 1'b0;   // Initialize divided clock to zero
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        clk_div <= ~clk_div; // Toggle divided clock output
    end
end

endmodule