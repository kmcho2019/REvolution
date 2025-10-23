module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Left shifts
    wire [63:0] shift_left_1 = q << 1;
    wire [63:0] shift_left_8 = q << 8;

    // Arithmetic right shifts
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Select left shift amount (1 or 8)
    wire [63:0] left_shift_sel = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;

    // Select right shift amount (1 or 8)
    wire [63:0] right_shift_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Select direction: 0=left, 1=right
    wire [63:0] shift_val = (amount[1] == 1'b0) ? left_shift_sel : right_shift_sel;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
    end

endmodule