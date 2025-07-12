module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] shift_reg;
    wire [2:0] select = {A, B, C};

    always @(posedge clk) begin
        if (enable) begin
            // Shift left, shifting in S at LSB side, so MSB is Q[0] = shift_reg[7]
            // After shifting left: shift_reg[7] <= shift_reg[6], ..., shift_reg[1] <= shift_reg[0], shift_reg[0] <= S
            shift_reg <= {shift_reg[6:0], S};
        end
    end

    always @(*) begin
        case (select)
            3'd0: Z = shift_reg[7]; // Q[0] = shift_reg[7]
            3'd1: Z = shift_reg[6];
            3'd2: Z = shift_reg[5];
            3'd3: Z = shift_reg[4];
            3'd4: Z = shift_reg[3];
            3'd5: Z = shift_reg[2];
            3'd6: Z = shift_reg[1];
            3'd7: Z = shift_reg[0];
            default: Z = 1'b0;
        endcase
    end

endmodule