module TopModule(
    input clock,
    input a,
    output p,
    output q
);

reg [1:0] shift_reg;

initial begin
    shift_reg = 2'b00;
end

always @(posedge clock) begin
    shift_reg <= {shift_reg[0], a};
end

assign p = shift_reg[0];
assign q = shift_reg[1];

endmodule