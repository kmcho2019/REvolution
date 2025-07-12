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

    // Shift register: shift left on enable, shift in S at LSB (shift_reg[0])
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    wire [2:0] select = {A, B, C};

    // Direct indexing of shift_reg by ABC (Q[0] = shift_reg[0], ..., Q[7] = shift_reg[7])
    assign Z = shift_reg[select];

endmodule