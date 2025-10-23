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

    // Shift register with Q[0] as LSB, shifting left, shift in S at LSB on enable
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Direct index using {A,B,C} to select output bit from shift_reg
    wire [2:0] select = {A, B, C};
    assign Z = shift_reg[select];

endmodule