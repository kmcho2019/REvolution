module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg = 8'h34; // Initialize q_reg with the desired reset value

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 8'h34; // Reset q_reg to the specified value
    end else begin
        // Update q_reg with d on the next negative edge of clk
        // This is achieved by using the current value of clk to determine
        // if the next clock cycle will be a negative edge
        if (~clk) begin
            q_reg <= d;
        end
    end
end

assign q = q_reg;

endmodule