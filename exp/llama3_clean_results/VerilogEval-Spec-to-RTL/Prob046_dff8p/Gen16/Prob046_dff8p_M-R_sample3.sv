// Define a TopModule with an 8-bit register
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'h34; // Initialize q_reg with the reset value

always @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset q_reg to 0x34
    end else begin
        q_reg <= d; // Update q_reg with the input d
    end
end

assign q = q_reg; // Assign the value of q_reg to the output q

endmodule