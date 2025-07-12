module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg [63:0] shift_val;

    // Implement shifts by concatenation to avoid variable shifters
    wire [63:0] shift_left_1  = {q[62:0], 1'b0};
    wire [63:0] shift_left_8  = {q[55:0], 8'b0};
    wire [63:0] shift_right_1 = {msb, q[63:1]};
    wire [63:0] shift_right_8 = {{8{msb}}, q[63:8]};

    // Combinational logic for shift_val selection using a case statement
    always @(*) begin
        case(amount)
            2'b00: shift_val = shift_left_1;    // shift left by 1
            2'b01: shift_val = shift_left_8;    // shift left by 8
            2'b10: shift_val = shift_right_1;   // shift right by 1 (arith)
            2'b11: shift_val = shift_right_8;   // shift right by 8 (arith)
            default: shift_val = q;              // default no shift (should not occur)
        endcase
    end

    // Sequential logic: synchronous load or shift on enable
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_val;
        end
    end

endmodule