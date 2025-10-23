module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] shift_reg;  // Stores last 3 bits
wire pattern_match;

// Shift register update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[1:0], data_in};
        // Registered output for clean timing
        sequence_detected <= pattern_match;
    end
end

// Optimized pattern detection for "1001"
// Looks for "100" in shift_reg and '1' in current input
assign pattern_match = (shift_reg == 3'b100) & data_in;

endmodule