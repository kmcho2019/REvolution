module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    wire [63:0] shift_left_1;
    wire [63:0] shift_left_8;
    wire [63:0] shift_right_1;
    wire [63:0] shift_right_8;

    // Shift left by 1: drop MSB, add 0 LSB
    assign shift_left_1  = {q[62:0], 1'b0};

    // Shift left by 8: drop top 8 bits, add 8 zeros LSB
    assign shift_left_8  = {q[55:0], 8'b0};

    // Arithmetic shift right by 1: replicate msb once, then bits 63 down to 1
    assign shift_right_1 = {msb, q[63:1]};

    // Arithmetic shift right by 8: replicate msb 8 times, then bits 63 down to 8
    assign shift_right_8 = {{8{msb}}, q[63:8]};

    // Intermediate wires for selected shift within each direction
    wire [63:0] left_shift_selected;
    wire [63:0] right_shift_selected;

    // Select shift amount within direction using simple mux (2:1)
    assign left_shift_selected  = (amount[0] == 1'b0) ? shift_left_1  : shift_left_8;
    assign right_shift_selected = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Direction select: 0 = left, 1 = right
    wire [63:0] shift_result = (amount[1] == 1'b0) ? left_shift_selected : right_shift_selected;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_result;
        end
    end

endmodule