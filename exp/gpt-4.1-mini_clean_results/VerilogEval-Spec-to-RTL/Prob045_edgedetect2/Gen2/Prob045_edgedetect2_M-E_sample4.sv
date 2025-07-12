module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] anyedge
);

    reg [1:0] shift_reg [7:0];
    integer i;

    // On every clock, shift in the new input bit into the 2-bit shift register for each bit
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            shift_reg[i] <= {shift_reg[i][0], in[i]};
        end
    end

    // The anyedge output is 1 if previous and current stored bits differ (edge detected on last cycle)
    assign anyedge = { 
        (shift_reg[7][1] ^ shift_reg[7][0]),
        (shift_reg[6][1] ^ shift_reg[6][0]),
        (shift_reg[5][1] ^ shift_reg[5][0]),
        (shift_reg[4][1] ^ shift_reg[4][0]),
        (shift_reg[3][1] ^ shift_reg[3][0]),
        (shift_reg[2][1] ^ shift_reg[2][0]),
        (shift_reg[1][1] ^ shift_reg[1][0]),
        (shift_reg[0][1] ^ shift_reg[0][0])
    };

endmodule