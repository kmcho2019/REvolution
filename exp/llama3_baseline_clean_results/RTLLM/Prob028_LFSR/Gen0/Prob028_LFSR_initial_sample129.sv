module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0000;
    end else begin
        // Calculate the feedback value
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the new feedback value
        state <= {state[2:0], feedback};
    end
end

// Assign the output to the current state of the LFSR
assign out = state;

endmodule