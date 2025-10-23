module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] state;

always @(posedge clk) begin
    state <= d;
end

assign q = state;

endmodule