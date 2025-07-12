module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] shift_reg; // shift register to store the previous state of the input signal

always @(posedge clk) begin
    shift_reg <= in; // update the shift register
end

always @(*) begin
    for (int i = 0; i < 8; i++) begin
        pedge[i] = in[i] && ~shift_reg[i]; // detect 0 to 1 transition using bitwise AND
    end
end

endmodule