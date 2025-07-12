// Corrected TopModule with 8 D flip-flops and asynchronous reset
module TopModule(
    input clk,
    input rst,  // Asynchronous reset signal
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q_reg <= 8'b0;  // Reset 'q_reg' to all zeros on reset
    end else begin
        q_reg <= d;  // Update 'q_reg' on positive edge of clock
    end
end

assign q = q_reg;

endmodule