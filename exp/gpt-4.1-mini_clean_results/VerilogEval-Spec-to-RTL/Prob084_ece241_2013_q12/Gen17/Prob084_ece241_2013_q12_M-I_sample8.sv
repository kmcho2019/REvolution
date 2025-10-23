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

    // Shift register with MSB as Q[0], shift in S at MSB (shift_reg[7]) and shift right
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    // Reverse shift_reg to get Q[0] at shift_reg_rev[0] ... Q[7] at shift_reg_rev[7]
    wire [7:0] shift_reg_rev = {shift_reg[0], shift_reg[1], shift_reg[2], shift_reg[3],
                               shift_reg[4], shift_reg[5], shift_reg[6], shift_reg[7]};

    // Use ABC as direct select index without inversion
    wire [2:0] select = {A, B, C};

    assign Z = shift_reg_rev[select];

endmodule