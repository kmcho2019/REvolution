module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

// Calculate the feedback signal
assign feedback = ~(state[3] ^ state[2]);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        // Reset the register to zero
        state <= 4'b0000;
    end else begin
        // Shift the bits left and insert the new feedback value at the LSB
        state <= {state[2:0], feedback};
    end
end

// Output the current state
assign out = state;

endmodule