module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

reg [3:0] shift_reg;

always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {data_in, shift_reg[3:1]};
    end
end

assign sequence_detected = (shift_reg == 4'b1001);

endmodule