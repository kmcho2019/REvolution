module sequence_detector (
    input wire clk,
    input wire reset_n,
    input wire data_in,
    output reg sequence_detected
);

parameter TARGET_PATTERN = 4'b1001;
reg [3:0] shift_reg;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0;
        sequence_detected <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
        sequence_detected <= (shift_reg == TARGET_PATTERN);
    end
end

endmodule