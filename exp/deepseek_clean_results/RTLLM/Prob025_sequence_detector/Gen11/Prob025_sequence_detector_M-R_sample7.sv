module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

wire [3:0] shift_reg;

// Shift register implemented with continuous assignments
assign shift_reg[0] = rst_n ? data_in : 1'b0;
assign shift_reg[1] = rst_n ? shift_reg[0] : 1'b0;
assign shift_reg[2] = rst_n ? shift_reg[1] : 1'b0;
assign shift_reg[3] = rst_n ? shift_reg[2] : 1'b0;

// Latch the shift register on clock edges
reg [3:0] stored_reg;
always @(posedge clk) begin
    stored_reg <= shift_reg;
end

// Parallel pattern matching
assign sequence_detected = (stored_reg == 4'b1001);

endmodule