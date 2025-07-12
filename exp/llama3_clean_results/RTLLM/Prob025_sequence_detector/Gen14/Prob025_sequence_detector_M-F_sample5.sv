module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output reg      sequence_detected
);

reg [3:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
        sequence_detected <= (shift_reg == 4'b1001)? 1'b1 : 1'b0;
    end
end

endmodule