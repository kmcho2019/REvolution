module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] state;

always @(posedge clk) begin
    // Rotate left and XOR with input
    state <= {state[6:0], state[7]} ^ d;
end

assign q = state;

endmodule