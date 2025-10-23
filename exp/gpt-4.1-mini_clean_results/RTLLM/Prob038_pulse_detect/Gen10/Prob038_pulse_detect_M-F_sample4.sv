module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [2:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 3'b000;
            data_out <= 1'b0;
        end else begin
            // Shift in current data_in sample
            shift_reg <= {shift_reg[1:0], data_in};
            // Check if the pattern 0->1->0 occurred in last 3 samples:
            // shift_reg[2] is oldest, shift_reg[1] is middle, shift_reg[0] is newest sample before data_in
            // But since we shift in data_in at the same clock edge, the current pattern is shift_reg:
            // The pattern to detect is shift_reg == 3'b010
            if (shift_reg == 3'b010) 
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule