module LFSR (
    input clk,
    input rst,
    output [3:0] out
);

reg [3:0] state;

always_ff @ (posedge clk) begin
    if (rst) begin
        state <= 4'b0;
    end else begin
        state <= {state[2:0], state[3] ^ state[2]};
    end
end

assign out = state;

endmodule