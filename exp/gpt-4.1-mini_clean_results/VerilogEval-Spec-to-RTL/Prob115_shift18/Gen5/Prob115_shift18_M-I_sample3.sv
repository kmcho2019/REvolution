module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Precompute all shift options
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    reg [63:0] shift_out;

    always @(*) begin
        case (amount)
            2'b00: shift_out = shift_left_1;   // shift left by 1
            2'b01: shift_out = shift_left_8;   // shift left by 8
            2'b10: shift_out = shift_right_1;  // arithmetic shift right by 1
            2'b11: shift_out = shift_right_8;  // arithmetic shift right by 8
            default: shift_out = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_out;
    end

endmodule