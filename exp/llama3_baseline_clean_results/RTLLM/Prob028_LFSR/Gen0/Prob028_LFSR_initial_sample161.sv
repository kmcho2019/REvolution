module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

assign out = state;

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0;
    end else begin
        // Calculate feedback signal by XORing MSB and second MSB, and then inverting
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift bits left and insert new feedback value at LSB
        state <= {state[2:0], feedback};
    end
end

endmodule