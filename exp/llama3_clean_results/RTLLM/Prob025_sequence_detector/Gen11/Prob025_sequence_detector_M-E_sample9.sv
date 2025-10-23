module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg;

// Shift register logic to store recent input bits
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0000;
        sequence_detected <= 0;
    end else begin
        shift_reg <= {data_in, shift_reg[3:1]};
        sequence_detected <= (shift_reg == 4'b1001)? 1'b1 : 0;
    end
end

endmodule