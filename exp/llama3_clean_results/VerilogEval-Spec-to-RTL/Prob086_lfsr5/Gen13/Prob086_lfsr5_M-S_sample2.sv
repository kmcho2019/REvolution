module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Initialize to a non-zero state
    end else begin
        state <= {state[2] ^ state[4] ^ state[0], state[4:1]}; // Corrected LFSR logic
    end
end

assign q = state;

endmodule