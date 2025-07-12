module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

wire [3:0] shift_reg;
reg [3:0] shift_reg_q;

// Shift register implemented with continuous assignments
assign shift_reg[0] = rst_n ? data_in : 1'b0;
assign shift_reg[1] = rst_n ? shift_reg_q[0] : 1'b0;
assign shift_reg[2] = rst_n ? shift_reg_q[1] : 1'b0;
assign shift_reg[3] = rst_n ? shift_reg_q[2] : 1'b0;

// Register the shifted values
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg_q <= 4'b0;
    else
        shift_reg_q <= shift_reg;
end

// Parallel pattern matching
assign sequence_detected = (shift_reg_q == 4'b1001);

endmodule