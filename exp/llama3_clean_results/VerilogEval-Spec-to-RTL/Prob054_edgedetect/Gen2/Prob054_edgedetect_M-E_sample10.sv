module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] shift_reg; // shift register to store previous values

always @(posedge clk) begin
    shift_reg <= {in, 7'b0}; // shift in the new value and fill the rest with zeros
    for (int i = 0; i < 8; i++) begin
        pedge[i] <= (shift_reg[i] == 0) && (in[i] == 1); // detect positive edge transition
    end
end

endmodule