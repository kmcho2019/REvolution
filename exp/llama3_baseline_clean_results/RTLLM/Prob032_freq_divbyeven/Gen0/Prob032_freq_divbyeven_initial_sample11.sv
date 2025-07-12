module freq_diveven #(
    parameter NUM_DIV = 10  // Must be an even number
) (
    input  logic clk,      // Input clock signal
    input  logic rst_n,    // Active-low reset signal
    output logic clk_div   // Divided clock output signal
);

// Counter to keep track of clock cycles
logic [3:0] cnt;

// Use NUM_DIV - 1 because we are checking if cnt is less than half of NUM_DIV - 1
localparam LIMIT = (NUM_DIV - 1) / 2;

// Generate divided clock signal on each positive edge of input clock
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt   <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // Check if counter has reached the specified limit
        if (cnt == LIMIT) begin
            // Reset counter and toggle divided clock signal
            cnt   <= 4'd0;
            clk_div <= ~clk_div;
        end else begin
            // Increment counter without changing divided clock signal
            cnt   <= cnt + 1'd1;
            clk_div <= clk_div;
        end
    end
end

endmodule