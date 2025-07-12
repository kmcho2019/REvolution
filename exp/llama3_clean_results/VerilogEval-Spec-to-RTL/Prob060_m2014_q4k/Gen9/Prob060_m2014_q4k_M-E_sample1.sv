// TopModule with Shift Register using a single register
module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;
assign out = shift_reg[0];

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
    end else begin
        shift_reg <= {in, shift_reg[3:1]};
    end
end

endmodule