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

    // Shift register with Q[0] as LSB (shift_reg[0]), shifting left and shifting in S
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Use ABC as select index directly: 000 -> Q[0], 001 -> Q[1], ..., 111 -> Q[7]
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule