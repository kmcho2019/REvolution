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
        data_out <= 0;
    end else begin
        shift_reg <= {shift_reg[0], data_in};
        data_out <= (shift_reg == 2'b01) && !data_in;
    end
end

endmodule