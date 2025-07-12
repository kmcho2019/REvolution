module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;
reg last_in;

always @(posedge clk) begin
    if (!resetn) begin
        shift_reg <= 4'b0000;
        last_in <= 1'b0;
    end else if (in != last_in) begin
        shift_reg <= {in, shift_reg[3:1]};
        last_in <= in;
    end else begin
        last_in <= in;
    end
end

assign out = shift_reg[0];

endmodule