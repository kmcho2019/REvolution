module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        state <= 4'b0000;
    end else begin
        // Calculate feedback
        reg feedback;
        assign feedback = ~(state[3] ^ state[2]);
        
        // Shift left and insert feedback at LSB
        state <= {state[2:0], feedback};
    end
end

assign out = state;

endmodule