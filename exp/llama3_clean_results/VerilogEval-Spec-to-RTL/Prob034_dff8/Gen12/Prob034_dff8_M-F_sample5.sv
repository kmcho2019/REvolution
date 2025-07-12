// Define the TopModule that includes 8 D flip-flops with reset
module TopModule(
    input clk,
    input rst_n, // Active low reset
    input [7:0] d,
    output reg [7:0] q
);

// Implement 8 D flip-flops using a single always block with reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 0; // Reset q to 0 when reset is asserted
    end else begin
        q <= d; // Update q with d when reset is not asserted
    end
end

endmodule