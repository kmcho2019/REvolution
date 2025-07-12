module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Explicit combinational shifts using concatenation to avoid shift operator complexity
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};

    wire [63:0] shift_right_1 = {msb, q[63:1]};         // arithmetic right shift by 1 with sign extension
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};    // arithmetic right shift by 8 with sign extension

    // Select shift amount within direction (amount[0])
    wire [63:0] left_shift_selected  = (amount[0] == 1'b0) ? shift_left_1  : shift_left_8;
    wire [63:0] right_shift_selected = (amount[0] == 1'b0) ? shift_right_1 : shift_right_8;

    // Select shift direction (amount[1])
    wire [63:0] shift_result = (amount[1] == 1'b0) ? left_shift_selected : right_shift_selected;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_result;
    end

endmodule