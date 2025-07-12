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
        shift_reg <= {data_in, shift_reg[2:1]};
        if (shift_reg == 3'b010) begin
            data_out <= 1;
        end else begin
            data_out <= 0;
        end
    end
end

endmodule