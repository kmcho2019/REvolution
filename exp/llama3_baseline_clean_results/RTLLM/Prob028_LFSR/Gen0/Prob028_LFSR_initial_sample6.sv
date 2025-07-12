module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

assign out = state;

always @(posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the state left and insert the feedback at the LSB
        state <= {state[2:0], feedback};
    end
end

endmodule