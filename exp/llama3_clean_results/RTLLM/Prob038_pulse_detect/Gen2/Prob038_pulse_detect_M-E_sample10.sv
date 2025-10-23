module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_reg <= 3'b000;
        data_out <= 0;
    end else begin
        shift_reg <= {shift_reg[1:0], data_in}; // Shift in the current value of data_in
        if (shift_reg == 3'b101) begin // Check for the pulse pattern (0-1-0)
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

endmodule