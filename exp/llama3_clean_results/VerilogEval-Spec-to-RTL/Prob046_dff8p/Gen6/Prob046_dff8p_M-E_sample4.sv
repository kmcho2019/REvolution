module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;

initial q_reg = 8'h34; // Set initial value of q_reg to 0x34

always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset q_reg to 0x34 if reset is high
    end else begin
        q_reg <= d; // Update q_reg with input d if reset is low
    end
end

assign q = q_reg;

endmodule