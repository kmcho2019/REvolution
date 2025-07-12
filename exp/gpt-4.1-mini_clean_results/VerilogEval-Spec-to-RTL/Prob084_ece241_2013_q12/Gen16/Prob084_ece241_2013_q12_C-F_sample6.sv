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
    wire [2:0] select = {A, B, C};
    wire [2:0] inv_select = 3'd7 - select;

    always @(posedge clk) begin
        if (enable) begin
            // Shift right, shifting in S at MSB (Q[0])
            shift_reg <= {S, shift_reg[7:1]};
        end
    end

    assign Z = shift_reg[inv_select];

endmodule