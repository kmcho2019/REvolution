module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 16; // Set MSB to 1 and rest to 0
    end else begin
        state <= {state[2] ^ state[4] ^ state[0], state[4:1]};
    end
end

assign q = state;

endmodule