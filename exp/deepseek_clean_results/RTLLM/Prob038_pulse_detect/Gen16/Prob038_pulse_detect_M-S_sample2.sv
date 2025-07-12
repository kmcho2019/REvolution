module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b0;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new data
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Detect 010 pattern
        data_out <= (shift_reg == 3'b010);
    end
end

endmodule