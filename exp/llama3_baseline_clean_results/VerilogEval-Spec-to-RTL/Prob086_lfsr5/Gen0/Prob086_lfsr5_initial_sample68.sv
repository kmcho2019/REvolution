module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 1;
    end else begin
        state <= {state[3] ^ state[0], state[4:1]};
    end
end

assign q = state;

endmodule