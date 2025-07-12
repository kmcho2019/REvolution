module TopModule(
    input  clk,
    input  reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001;  // reset to 1
    end else begin
        state <= {state[3] ^ state[0], state[4:1]};  // tap at positions 5 (MSB) and 3
    end
end

assign q = state;

endmodule