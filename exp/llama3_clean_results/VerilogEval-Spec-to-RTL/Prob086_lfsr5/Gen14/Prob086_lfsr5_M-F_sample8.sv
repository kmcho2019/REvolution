module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state; // Current state of the LFSR

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b00001; // Set the LFSR output to 1
    end else if (state!= 5'b00000) begin
        state <= {state[3] ^ state[0], state[4:1]}; // Update state
    end
end

assign q = state; // Output the current state of the LFSR

endmodule