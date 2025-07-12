module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Define the ring counter width based on the division factor
localparam RING_COUNTER_WIDTH = (NUM_DIV / 2);

// Ring counter register
reg [RING_COUNTER_WIDTH-1:0] ring_counter;

// Initialize the ring counter and divided clock output
initial begin
    ring_counter = 0;
    clk_div = 0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the ring counter and divided clock output on reset
        ring_counter <= 0;
        clk_div <= 0;
    end else begin
        // Shift the ring counter to the right
        ring_counter <= {ring_counter[RING_COUNTER_WIDTH-2:0], 1'b0};
        
        // Check if the ring counter has reached the specified limit
        if (ring_counter == (1'b1 << (RING_COUNTER_WIDTH-1))) begin
            // Reset the ring counter and toggle the divided clock output
            ring_counter <= 0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule