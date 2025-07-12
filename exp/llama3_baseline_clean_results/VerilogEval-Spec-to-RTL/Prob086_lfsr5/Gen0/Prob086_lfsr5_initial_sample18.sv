module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 5'b10000; // initialize with 1
    end else begin
        state[4] <= state[3] ^ state[0]; // tap at position 5
        state[3] <= state[2] ^ state[0]; // tap at position 3
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= 0; // this will be overwritten by the XOR result of state[4] and state[3]
        // but we need to assign something to avoid a latch, and 0 is a don't care here
    end
end

assign q = state;

endmodule