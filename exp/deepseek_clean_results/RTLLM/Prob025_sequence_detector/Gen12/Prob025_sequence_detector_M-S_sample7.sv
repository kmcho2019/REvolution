module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

reg [3:0] shift_reg;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        shift_reg <= 4'b0;
    else
        shift_reg <= {shift_reg[2:0], data_in};
end

assign sequence_detected = (shift_reg == 4'b1001);

endmodule