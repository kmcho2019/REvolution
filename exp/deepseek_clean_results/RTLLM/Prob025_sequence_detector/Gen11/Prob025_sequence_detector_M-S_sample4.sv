module sequence_detector (
    input clk,
    input data_in,
    output sequence_detected
);

reg [3:0] shift_reg;

always @(posedge clk)
    shift_reg <= {shift_reg[2:0], data_in};

assign sequence_detected = (shift_reg == 4'b1001);

endmodule