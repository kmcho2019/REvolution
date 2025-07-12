module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    // Initialize output to zero for simulation consistency
    initial q = 8'b0;

    // On each positive edge of clk, capture d into q
    always @(posedge clk) begin
        q <= d;
    end

endmodule