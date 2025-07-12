module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

integer i;
initial q = 8'b0;  // Initialize all flip-flops to zero

always @(posedge clk) begin
    for (i = 0; i < 8; i = i + 1) begin
        q[i] <= d[i];
    end
end

endmodule