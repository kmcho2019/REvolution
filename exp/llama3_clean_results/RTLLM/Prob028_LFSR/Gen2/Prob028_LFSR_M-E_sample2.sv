module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    input [3:0] init_state, // Initial state of the LFSR
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // Variable to hold the current state of the LFSR
wire feedback_xor; // Wire for XOR feedback
wire feedback_xnor; // Wire for XNOR feedback
wire final_feedback; // Final feedback after combining XOR and XNOR results

// Calculate XOR feedback
assign feedback_xor = state[3] ^ state[1];

// Calculate XNOR feedback
assign feedback_xnor = ~(state[2] ^ state[0]);

// Combine XOR and XNOR feedbacks
assign final_feedback = feedback_xor & feedback_xnor;

// Sequential logic block to update the LFSR state
always @ (posedge clk or posedge rst) begin
    if (rst) begin // If reset is high, initialize the register with the provided initial state
        state <= init_state;
    end else begin // Otherwise, shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], final_feedback};
    end
end

// Assign the current state of the LFSR to the output port
assign out = state;

endmodule