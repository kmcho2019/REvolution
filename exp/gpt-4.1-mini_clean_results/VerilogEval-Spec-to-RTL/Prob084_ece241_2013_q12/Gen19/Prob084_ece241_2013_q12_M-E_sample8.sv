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

    // On each posedge clk, if enable, shift left and insert S at LSB
    // shift_reg[7] <= shift_reg[6]
    // ...
    // shift_reg[1] <= shift_reg[0]
    // shift_reg[0] <= S
    always @(posedge clk) begin
        if (enable) begin
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    // Use ABC as direct select index to choose output bit from shift_reg
    wire [2:0] select = {A, B, C};

    assign Z = shift_reg[select];

endmodule