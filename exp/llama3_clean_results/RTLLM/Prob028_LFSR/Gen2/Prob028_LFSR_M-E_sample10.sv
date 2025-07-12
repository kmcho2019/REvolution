// Module to calculate the next state of the LFSR
module lfsr_next_state(
    input [3:0] current_state,
    output reg [3:0] next_state
);

assign next_state = {current_state[2:0], ~(current_state[3] ^ current_state[2])};

endmodule

// Main LFSR module
module LFSR(
    input clk,  // Clock signal
    input rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

lfsr_next_state next_state_generator(
    .current_state(out),
    .next_state(out)
);

always @ (posedge clk) begin
    if (rst) begin
        out <= 4'b0000; // Reset the LFSR to zero when rst is high
    end else begin
        out <= next_state_generator.next_state;
    end
end

endmodule