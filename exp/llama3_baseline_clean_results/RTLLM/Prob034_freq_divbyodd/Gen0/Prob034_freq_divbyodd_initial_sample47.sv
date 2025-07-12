module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input clk,            // Input clock signal
    input rst_n,          // Active low reset signal
    output reg clk_div    // Divided clock output
);

// Internal signals
reg [2:0] cnt1;          // Counter for rising edge
reg [2:0] cnt2;          // Counter for falling edge
reg clk_div1;             // Clock divider for positive edge
reg clk_div2;             // Clock divider for negative edge
reg prev_clk;             // Previous clock value for edge detection

// Parameter validation (NUM_DIV must be odd)
initial begin
    if (NUM_DIV % 2 == 0) begin
        $display("Error: NUM_DIV must be an odd number.");
        $finish;
    end
end

// Main logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        // Edge detection
        if (clk != prev_clk) begin
            if (clk) begin  // Rising edge
                if (cnt1 == (NUM_DIV - 1) / 2) begin
                    clk_div1 <= ~clk_div1;
                end
                cnt1 <= cnt1 + 1;
                if (cnt1 == (NUM_DIV - 1)) begin
                    cnt1 <= 0;
                end
            end else begin  // Falling edge
                if (cnt2 == (NUM_DIV - 1) / 2) begin
                    clk_div2 <= ~clk_div2;
                end
                cnt2 <= cnt2 + 1;
                if (cnt2 == (NUM_DIV - 1)) begin
                    cnt2 <= 0;
                end
            end
        end
        prev_clk <= clk;
    end
end

// Derive final divided clock output
always @(clk_div1 or clk_div2) begin
    clk_div <= clk_div1 | clk_div2;
end

endmodule