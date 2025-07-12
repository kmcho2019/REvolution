module TopModule (
    input clk,
    input rst_n,    // Active-low asynchronous reset
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 8'b0;  // Reset all flip-flops to 0
    end else begin
        q <= d;     // Normal operation
    end
end

endmodule