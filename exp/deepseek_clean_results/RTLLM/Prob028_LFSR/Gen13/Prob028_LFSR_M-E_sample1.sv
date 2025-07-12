module LFSR (
    input wire clk,            // Clock input
    input wire rst,            // Active-high synchronous reset
    input wire serial_mode,    // 0=parallel output, 1=serial output
    output reg [3:0] out,      // Parallel output (current state)
    output wire random_bit     // Serial output (LSB)
);

parameter [3:0] FEEDBACK_MASK = 4'b1100; // Default: x^4 + x^3 + 1

reg [3:0] state;
reg [3:0] parallel_buffer;
reg [1:0] cycle_counter;

// Calculate feedback using configurable polynomial
wire feedback = ^(state & FEEDBACK_MASK);

// Auto-correct all-zero state
wire [3:0] next_state = (state == 4'b0000) ? 4'b0001 : 
                       {state[2:0], feedback};

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0001;
        parallel_buffer <= 4'b0000;
        cycle_counter <= 2'b00;
    end
    else begin
        state <= next_state;
        
        // Update parallel buffer every 4 cycles
        if (cycle_counter == 2'b11) begin
            parallel_buffer <= next_state;
        end
        cycle_counter <= cycle_counter + 1;
    end
end

// Output selection logic
always @(*) begin
    out = serial_mode ? {3'b0, state[0]} : parallel_buffer;
end

assign random_bit = state[0];

endmodule