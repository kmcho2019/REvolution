// Define the module for the 64-bit Johnson counter using LFSR and control logic
module JC_counter_lfsr(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Internal signals for LFSR and control logic
reg [63:0] lfsr_out;
reg [63:0] next_state;

// LFSR implementation
always @(posedge clk) begin
    if (~rst_n) begin
        lfsr_out <= 64'd0;
    end else begin
        // LFSR feedback logic
        lfsr_out <= {lfsr_out[62:0], lfsr_out ^ lfsr_out[0]};
    end
end

// Control logic for state transitions
always @(*) begin
    if (~rst_n) begin
        next_state = 64'd0;
    end else begin
        // Determine next state based on current state and LFSR output
        if (Q == 1'b) begin
            next_state = {'b0, Q[63:1]};
        end else begin
            next_state = {1'b1, Q[63:1]};
        end
    end
end

// Update output register
always @(posedge clk) begin
    Q <= next_state;
end

endmodule