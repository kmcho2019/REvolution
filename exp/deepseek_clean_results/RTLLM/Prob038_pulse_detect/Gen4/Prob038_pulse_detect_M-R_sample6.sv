module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000;
        data_out <= 0;
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Detect 010 pattern (MSB is oldest bit)
        if (shift_reg == 3'b010) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

endmodule