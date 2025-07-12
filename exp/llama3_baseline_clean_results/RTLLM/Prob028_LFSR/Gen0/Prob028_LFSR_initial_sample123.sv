module LFSR(
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

assign out = state;

always @ (posedge clk) begin
    if (rst) begin
        state <= 4'd0;
    end else begin
        state <= {state[2:0], ~(state[3] ^ state[2])};
    end
end

endmodule