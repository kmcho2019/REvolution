// Module JC_counter: Modular 64-bit Johnson counter
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Parameters for modularization
parameter SUB_COUNTER_SIZE = 8; // Size of each sub-counter
parameter NUM_SUB_COUNTERS = 8; // Number of sub-counters

// Type definition for sub-counter array
typedef reg [SUB_COUNTER_SIZE-1:0] sub_counter_t;

// Array to hold sub-counters
sub_counter_t sub_counters [NUM_SUB_COUNTERS-1:0];

// Always block for sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Initialize all sub-counters to 0
        for (int i = 0; i < NUM_SUB_COUNTERS; i++) begin
            sub_counters[i] <= '0;
        end
        Q <= 64'd0;
    end
    else begin
        // Update sub-counters based on their least significant bits
        for (int i = 0; i < NUM_SUB_COUNTERS; i++) begin
            if (sub_counters[i][0] == 1'b0) begin
                // If LSB is 0, append 1 to MSB
                sub_counters[i] <= {1'b1, sub_counters[i][SUB_COUNTER_SIZE-1:1]};
            end
            else begin
                // If LSB is 1, append 0 to MSB
                sub_counters[i] <= {1'b0, sub_counters[i][SUB_COUNTER_SIZE-1:1]};
            end
        end
        
        // Concatenate sub-counters to form the final 64-bit counter value
        Q <= {sub_counters[NUM_SUB_COUNTERS-1], sub_counters[NUM_SUB_COUNTERS-2], sub_counters[NUM_SUB_COUNTERS-3], sub_counters[NUM_SUB_COUNTERS-4],
               sub_counters[NUM_SUB_COUNTERS-5], sub_counters[NUM_SUB_COUNTERS-6], sub_counters[NUM_SUB_COUNTERS-7], sub_counters[0]};
    end
end

endmodule