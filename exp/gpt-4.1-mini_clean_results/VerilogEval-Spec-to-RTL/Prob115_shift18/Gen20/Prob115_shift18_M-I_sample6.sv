module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Precompute all shifts
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Register shift value gated by ena to reduce toggling
    reg [63:0] shift_val;
    always @(*) begin
        case(amount)
            2'b00: shift_val = shift_left_1;
            2'b01: shift_val = shift_left_8;
            2'b10: shift_val = shift_right_1;
            2'b11: shift_val = shift_right_8;
            default: shift_val = q; // default case safe
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_val;
    end

endmodule