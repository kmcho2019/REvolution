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
    reg [7:0] next_shift_reg;
    wire [2:0] select = {A, B, C};

    // Combinational logic for next shift register state
    always @(*) begin
        if (enable)
            next_shift_reg = {shift_reg[6:0], S};
        else
            next_shift_reg = shift_reg;
    end

    // Sequential update of shift register on clock
    always @(posedge clk) begin
        shift_reg <= next_shift_reg;
    end

    // Multiplexer implemented as case statement for clarity
    always @(*) begin
        case (select)
            3'b000: Z = shift_reg[0];
            3'b001: Z = shift_reg[1];
            3'b010: Z = shift_reg[2];
            3'b011: Z = shift_reg[3];
            3'b100: Z = shift_reg[4];
            3'b101: Z = shift_reg[5];
            3'b110: Z = shift_reg[6];
            3'b111: Z = shift_reg[7];
            default: Z = 1'b0;
        endcase
    end

endmodule