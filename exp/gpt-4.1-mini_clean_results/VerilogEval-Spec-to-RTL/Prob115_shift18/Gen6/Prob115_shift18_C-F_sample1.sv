module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Capture MSB for arithmetic right shift sign extension
    wire msb = q[63];

    // Precompute shifted values:
    // Left shifts by 1 and 8 bits (fill right bits with zeros)
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};

    // Arithmetic right shifts by 1 and 8 bits (fill left bits with msb)
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select shifted output based on amount:
    // amount[1] = direction (0 = left, 1 = arithmetic right)
    // amount[0] = shift by 1 (0) or 8 (1)
    reg [63:0] shifted;
    always @(*) begin
        case (amount)
            2'b00: shifted = shift_left_1;
            2'b01: shifted = shift_left_8;
            2'b10: shifted = shift_right_1;
            2'b11: shifted = shift_right_8;
            default: shifted = q; // default safe hold (should not occur)
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule