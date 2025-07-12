module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;
assign q = state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= 1;
    end else begin
        state <= {state[4] ^ state[2] ^ state[0], state[4:1]};
    end
end

endmodule