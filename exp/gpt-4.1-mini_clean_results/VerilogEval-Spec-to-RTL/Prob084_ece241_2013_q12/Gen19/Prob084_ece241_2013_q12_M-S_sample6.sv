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

    // Shift register: shift left, S shifted into LSB (Q[0])
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Use ABC as direct select index to choose output bit from shift_reg
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule