module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d;    // Update flip-flops on positive clock edge
end

endmodule