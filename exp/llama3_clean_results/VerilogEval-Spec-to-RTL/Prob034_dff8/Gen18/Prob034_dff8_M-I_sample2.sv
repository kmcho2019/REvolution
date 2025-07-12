// Improved TopModule with 8 D flip-flops and optional reset
module TopModule(
    input clk,
    input rst_n, // Active low reset
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset q to a known state
        q <= 8'b0;
    end else begin
        // Capture input d at the positive edge of clk and assign to q
        q <= d;
    end
end

endmodule