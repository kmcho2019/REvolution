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

    // On each clock edge, shift left if enable is high, input S into LSB (Q[0])
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Use ABC as direct index for output Z from shift_reg (Q[0]=shift_reg[0])
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule