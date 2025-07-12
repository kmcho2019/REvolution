module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    wire [63:0] shifted;

    // Determine shift direction and amount
    // amount encoding:
    // 00: shift left by 1
    // 01: shift left by 8
    // 10: shift right by 1 (arithmetic)
    // 11: shift right by 8 (arithmetic)

    // Create barrel shifter combining all cases:
    wire shift_left = (amount[1] == 1'b0);
    wire shift_by_1 = (amount[0] == 1'b0);

    // Shift left by 1 or 8
    wire [63:0] shift_left_1  = q << 1;
    wire [63:0] shift_left_8  = q << 8;

    // Arithmetic shift right by 1 or 8: fill left bits with msb
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select left or right shifts based on amount[1]
    wire [63:0] shift1 = (shift_left) ? 
                        (shift_by_1 ? shift_left_1 : shift_left_8) :
                        (shift_by_1 ? shift_right_1 : shift_right_8);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift1;
        end
    end

endmodule