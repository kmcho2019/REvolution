module freq_diveven #(
    parameter NUM_DIV = 10  // Even number specifying the division factor
)(
    input  clk,            // Input clock signal
    input  rst_n,          // Active-low reset signal
    output reg  clk_div    // Divided clock output signal
);

// Validate that NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $error("NUM_DIV must be an even number.");
    end
end

// Calculate the required width for the counter
localparam CNT_WIDTH = $clog2(NUM_DIV / 2);

reg [CNT_WIDTH-1:0] cnt;  // Counter with dynamic width

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin      // Active-low reset
        cnt <= {CNT_WIDTH{1'b0}}; // Initialize counter to zero
        clk_div <= 1'b0;   // Initialize divided clock to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter
        end else begin
            cnt <= {CNT_WIDTH{1'b0}}; // Reset counter
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule