module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] q_reg;
reg [7:0] reset_value_reg;

// SIPO Shift Register to load reset value
always @(posedge clk) begin
    if (reset) begin
        // Load reset value serially into reset_value_reg
        reset_value_reg <= {reset_value_reg[6:0], 1'b0}; // Assuming 0x34 is loaded MSB first
        // After 8 clocks, reset_value_reg should hold the reset value
        // For simplicity, let's assume the reset value is hardcoded as 8'h34
        if (&reset_value_reg) begin // All bits set to 1 indicates loading complete
            reset_value_reg <= 8'h34;
        end
    end
end

// D Flip-Flops with active high synchronous reset
always_ff @(negedge clk) begin
    if (reset) begin
        q_reg <= reset_value_reg; // Reset DFFs with loaded reset value
    end else begin
        q_reg <= d; // Normal operation: load input data
    end
end

assign q = q_reg;

endmodule