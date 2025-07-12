module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // Set the LFSR output to 1
    end else begin
        state <= {state[2] ^ state[0], state[4:1]}; // Update state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule