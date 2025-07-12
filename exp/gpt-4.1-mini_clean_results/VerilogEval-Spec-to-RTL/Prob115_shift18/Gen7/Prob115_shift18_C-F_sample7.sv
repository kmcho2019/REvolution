module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Shift left by 1 bit: drop MSB, LSB = 0
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    // Shift left by 8 bits: drop upper 8 bits, fill LSB 8 bits with 0
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};

    // Arithmetic shift right by 1 bit: MSB replicated, rest shifted right by 1
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    // Arithmetic shift right by 8 bits: replicate MSB 8 times, then upper bits shifted right by 8
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // First level mux: select shift amount within each direction
    wire [63:0] shift_left_sel  = (amount[0] == 1'b0) ? shift_left_1 : shift_left_8;
    wire [63:0] shift_right_sel = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Second level mux: select shift direction
    wire [63:0] shift_val = (amount[1] == 1'b0) ? shift_left_sel : shift_right_sel;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
    end

endmodule