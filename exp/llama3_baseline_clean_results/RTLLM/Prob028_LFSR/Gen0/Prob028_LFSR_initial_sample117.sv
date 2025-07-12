module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0000;
    end else begin
        // Calculate the feedback signal
        wire feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits to the left and insert the feedback signal at the LSB
        state <= {state[2:0], feedback};
    end
end

assign out = state;

endmodule