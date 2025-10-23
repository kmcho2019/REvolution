module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output
);

reg [3:0] state; // Internal state of the LFSR

// Feedback calculation: XOR of MSB and second MSB, then invert the result
assign out = state;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        // Asynchronous reset: initialize state to 0
        state <= 4'b0000;
    end else begin
        // Calculate feedback: XOR of MSB and second MSB, then invert
        reg fb;
        assign fb = ~(state[3] ^ state[2]);
        
        // Shift left and insert feedback at LSB
        state <= {state[2:0], fb};
    end
end

endmodule