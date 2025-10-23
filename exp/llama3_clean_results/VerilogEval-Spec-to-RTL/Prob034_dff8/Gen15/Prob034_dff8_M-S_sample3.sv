module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'd0 // Initialize q to 0
);

always @(posedge clk) begin
    q = d;
end

endmodule