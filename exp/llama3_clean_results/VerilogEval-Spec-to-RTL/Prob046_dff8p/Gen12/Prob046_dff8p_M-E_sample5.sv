module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
wire [7:0] reset_value = 8'h34; // Reset value

always @(negedge clk) begin
    if (reset) begin
        q_reg <= reset_value; // Load reset values when reset is high
    end else begin
        q_reg <= {q_reg[6:0], d[7]}; // Shift operation to load new data
    end
end

assign q = q_reg;

endmodule