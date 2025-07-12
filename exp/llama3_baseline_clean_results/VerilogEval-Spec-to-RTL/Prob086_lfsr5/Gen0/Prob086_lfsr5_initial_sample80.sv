module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 5'b10000; // reset the LFSR output to 1
    end else begin
        state <= {state[2] ^ state[0], state[4:1]}; // shift and XOR
    end
end

assign q = state;

endmodule