module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

    reg [7:0] shift_reg;

    // Shift register with MSB as Q[0], shifting right and shifting in S
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    // Use ABC as select index: ABC forms a 3-bit number to index shift_reg
    // Q[0] is shift_reg[7], Q[7] is shift_reg[0], so need to invert index for correct mapping
    wire [2:0] select = {A, B, C};
    wire [2:0] inv_select = 3'd7 - select;

    assign Z = shift_reg[inv_select];

endmodule