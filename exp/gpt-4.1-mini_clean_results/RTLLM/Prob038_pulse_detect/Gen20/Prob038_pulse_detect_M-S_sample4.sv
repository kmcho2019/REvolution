module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    reg [1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 2'b00;
            data_out <= 1'b0;
        end else begin
            shift_reg <= {shift_reg[0], data_in};
            // Detect pattern 0 1 0 on {shift_reg[1], shift_reg[0], data_in}
            if ({shift_reg, data_in} == 3'b010)
                data_out <= 1'b1;
            else
                data_out <= 1'b0;
        end
    end

endmodule