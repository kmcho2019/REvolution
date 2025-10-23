module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0  // Initialize output register to zero
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule