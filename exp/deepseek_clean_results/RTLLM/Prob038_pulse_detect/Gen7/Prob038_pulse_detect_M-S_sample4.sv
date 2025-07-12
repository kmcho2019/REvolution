module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 2'b00;
        data_out <= 1'b0;
    end else begin
        // Shift in new data_in value
        shift_reg <= {shift_reg[0], data_in};
        
        // Detect 010 pattern (current data_in is 0, previous was 1, before that was 0)
        data_out <= (data_in == 1'b0) && (shift_reg == 2'b01);
    end
end

endmodule