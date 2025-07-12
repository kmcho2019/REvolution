module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Initialize to 1, ensuring a non-zero start state for the maximal-length sequence
    end else begin
        state <= {state[2] ^ state[0], state[4:1]}; // Corrected tap positions and shift
    end
end

assign q = state;

endmodule