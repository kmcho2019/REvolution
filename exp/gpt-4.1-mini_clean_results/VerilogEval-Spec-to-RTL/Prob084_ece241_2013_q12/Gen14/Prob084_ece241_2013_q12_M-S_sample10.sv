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

    // Shift register: shift right, shifting in S at MSB (Q[0] = shift_reg[7])
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    // Calculate index = 7 - {A,B,C}
    wire [2:0] select = {A, B, C};
    wire [2:0] idx = 3'd7 - select;

    assign Z = shift_reg[idx];

endmodule