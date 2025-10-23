module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Precompute all four shifted values using concatenation for clarity and synthesis friendliness
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    reg [63:0] shift_val;

    always @(*) begin
        case(amount)
            2'b00: shift_val = shift_left_1;   // shift left by 1
            2'b01: shift_val = shift_left_8;   // shift left by 8
            2'b10: shift_val = shift_right_1;  // shift right by 1 arithmetic
            2'b11: shift_val = shift_right_8;  // shift right by 8 arithmetic
            default: shift_val = q;             // safe fallback, should not occur
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_val;
    end

endmodule