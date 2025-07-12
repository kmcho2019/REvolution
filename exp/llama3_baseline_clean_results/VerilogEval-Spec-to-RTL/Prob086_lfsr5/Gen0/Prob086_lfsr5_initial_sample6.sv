module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

initial state = 5'b00001;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000;
    end else begin
        state[4] <= state[3];
        state[3] <= state[2];
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= state[4] ^ state[2];
    end
end

assign q = state;

endmodule