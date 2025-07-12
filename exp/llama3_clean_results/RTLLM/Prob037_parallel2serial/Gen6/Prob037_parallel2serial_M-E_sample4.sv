module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] shift_reg;
reg valid_out;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 0;
        valid_out <= 0;
    end else if (valid_out == 0) begin
        shift_reg <= d;
        valid_out <= 1;
    end else begin
        shift_reg <= shift_reg >> 1;
        if (shift_reg == 0) begin
            valid_out <= 0;
        end
    end
end

assign dout = shift_reg[3];

endmodule