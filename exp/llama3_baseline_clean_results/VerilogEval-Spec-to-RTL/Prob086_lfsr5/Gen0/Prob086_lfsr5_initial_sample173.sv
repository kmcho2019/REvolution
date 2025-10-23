module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

initial state = 5'b1;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b1;
    end else begin
        state[4] <= state[3] ^ state[0]; // tap at position 5
        state[3] <= state[2] ^ state[0]; // tap at position 3
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= 0; // shift right
    end
end

assign q = state;

endmodule