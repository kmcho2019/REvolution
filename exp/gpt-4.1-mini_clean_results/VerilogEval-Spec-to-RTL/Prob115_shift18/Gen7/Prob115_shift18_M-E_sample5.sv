module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire direction = amount[1]; // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];

    wire msb = q[63];

    wire [63:0] shifted_left_1;
    wire [63:0] shifted_left_8;
    wire [63:0] shifted_right_1;
    wire [63:0] shifted_right_8;

    // Shift left by 1 bit: bits [62:0] shifted left, LSB zero
    assign shifted_left_1 = {q[62:0], 1'b0};

    // Shift left by 8 bits: bits [55:0] shifted left, lowest 8 bits zero
    assign shifted_left_8 = {q[55:0], 8'b0};

    // Arithmetic shift right by 1 bit: MSB replicated, bits [63:1] shifted right by 1
    assign shifted_right_1 = {msb, q[63:1]};

    // Arithmetic shift right by 8 bits: MSB replicated for upper 8 bits, bits [63:8] shifted right by 8
    assign shifted_right_8 = {{8{msb}}, q[63:8]};

    // Select shift result based on amount
    wire [63:0] shifted = (direction == 1'b0) ? // left shift
                          (shift_by_8 ? shifted_left_8 : shifted_left_1)
                          : // arithmetic right shift
                          (shift_by_8 ? shifted_right_8 : shifted_right_1);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold current q
    end

endmodule