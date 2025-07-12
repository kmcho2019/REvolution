module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] internal_state; // Internal signal to represent the state of the 8 DFFs

always @(posedge clk) begin
    internal_state <= d; // Update the internal state with the input d on each positive clock edge
    q <= internal_state; // Update the output q with the internal state
end

endmodule