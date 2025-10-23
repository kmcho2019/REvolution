module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;
wire pattern_match;

// Shift register update
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
        sequence_detected <= pattern_match;
    end
end

// Pattern matching: 1001 (MSB first)
assign pattern_match = (shift_reg == 4'b1001);

endmodule