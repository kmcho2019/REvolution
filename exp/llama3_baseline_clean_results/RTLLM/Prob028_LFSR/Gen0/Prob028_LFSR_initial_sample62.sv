module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

// Initialize the state to zero when rst is high
always @(posedge clk) begin
    if (rst) begin
        state <= 4'd0;
    end else begin
        // Calculate feedback by XORing MSB and second MSB, then inverting
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift left and insert feedback at LSB
        state <= {state[2:0], feedback};
    end
end

// Continuous assignment to output the current state
assign out = state;

endmodule