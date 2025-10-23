module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire direction = amount[1];  // 0: left shift, 1: arithmetic right shift
    wire [5:0] shift_val;        // shift amount in bits

    // Decode shift amount
    // amount encoding:
    // 00: shift left by 1
    // 01: shift left by 8
    // 10: shift right by 1 (arith)
    // 11: shift right by 8 (arith)
    assign shift_val = (amount[0] == 1'b0) ? 6'd1 : 6'd8;

    wire [63:0] shifted;

    // Barrel shifter combinational logic
    // For left shift, shift left by shift_val, zero fill right
    // For arithmetic right shift, shift right by shift_val, sign extend left with MSB

    // Use conditional shift logic implemented with mux levels for performance:
    // But since shift_val is only 1 or 8, use direct shifting operators and sign extension.

    wire [63:0] left_shifted  = q << shift_val;

    wire [63:0] right_shifted_arith;
    wire msb = q[63];
    // Arithmetic right shift by shift_val
    // replicate msb on shifted-in bits
    assign right_shifted_arith = (q >> shift_val) | ({64{msb}} << (64 - shift_val));

    assign shifted = (direction == 1'b0) ? left_shifted : right_shifted_arith;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule