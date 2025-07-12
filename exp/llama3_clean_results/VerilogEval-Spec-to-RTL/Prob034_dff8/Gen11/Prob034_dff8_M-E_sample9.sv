// Novel TopModule implementation using a for-loop
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    for (int i = 0; i < 8; i++) begin
        q[i] <= d[i]; // Assign each bit of d to q
    end
end

endmodule