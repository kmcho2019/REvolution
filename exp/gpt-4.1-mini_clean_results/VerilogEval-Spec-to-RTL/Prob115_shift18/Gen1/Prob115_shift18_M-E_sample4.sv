module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    // Intermediate signals for shifts
    wire [63:0] shift_left_1;
    wire [63:0] shift_left_8;
    wire [63:0] shift_right_1;
    wire [63:0] shift_right_8;

    // Arithmetic right shift replicate bit
    wire sign_bit = q[63];

    // Shift left by 1
    assign shift_left_1 = {q[62:0], 1'b0};
    // Shift left by 8
    assign shift_left_8 = {q[55:0], 8'b0};

    // Arithmetic shift right by 1
    assign shift_right_1 = {sign_bit, q[63:1]};
    // Arithmetic shift right by 8
    assign shift_right_8 = {{8{sign_bit}}, q[63:8]};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= shift_left_1;
                2'b01: q <= shift_left_8;
                2'b10: q <= shift_right_1;
                2'b11: q <= shift_right_8;
                default: q <= q;
            endcase
        end
    end

endmodule