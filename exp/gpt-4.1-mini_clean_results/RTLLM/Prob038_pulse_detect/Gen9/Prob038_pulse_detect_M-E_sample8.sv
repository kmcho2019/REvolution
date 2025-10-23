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
            // Shift in new bit
            shift_reg <= {shift_reg[1:0], data_in};
            // Assert data_out if pattern "010" detected
            data_out <= (shift_reg == 3'b010);
        end
    end

endmodule