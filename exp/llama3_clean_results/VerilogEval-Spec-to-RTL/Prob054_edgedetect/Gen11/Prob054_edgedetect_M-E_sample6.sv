module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

// Shift register to store the current and previous states of the input bits
reg [7:0] shift_reg;

// Initialize the shift register
initial shift_reg = 8'b0;

// Always block to update the shift register and detect positive edges
always @(posedge clk) begin
    // Shift the previous input into the shift register
    shift_reg <= {shift_reg[6:0], in[7]};
    
    // Detect positive edges by comparing the current input with the previous input
    pedge[7] <= in[7] & ~shift_reg[7];
    pedge[6] <= in[6] & ~shift_reg[6];
    pedge[5] <= in[5] & ~shift_reg[5];
    pedge[4] <= in[4] & ~shift_reg[4];
    pedge[3] <= in[3] & ~shift_reg[3];
    pedge[2] <= in[2] & ~shift_reg[2];
    pedge[1] <= in[1] & ~shift_reg[1];
    pedge[0] <= in[0] & ~shift_reg[0];
end

endmodule