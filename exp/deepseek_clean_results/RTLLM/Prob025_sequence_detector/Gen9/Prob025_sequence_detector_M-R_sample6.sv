module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

wire [3:0] shift_reg;

// Shift register implemented with continuous assignments
assign shift_reg[0] = !rst_n ? 1'b0 : data_in;
assign shift_reg[1] = !rst_n ? 1'b0 : shift_reg[0];
assign shift_reg[2] = !rst_n ? 1'b0 : shift_reg[1];
assign shift_reg[3] = !rst_n ? 1'b0 : shift_reg[2];

// Clocked version of the shift register
reg [3:0] shift_reg_ff;
always @(posedge clk) begin
    shift_reg_ff <= shift_reg;
end

// Parallel pattern matching
assign sequence_detected = (shift_reg_ff == 4'b1001);

endmodule