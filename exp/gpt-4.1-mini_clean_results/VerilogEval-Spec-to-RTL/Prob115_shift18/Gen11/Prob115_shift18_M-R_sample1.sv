module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Internal combinational function to perform shift operation
    // q_in: current register value
    // dir: 0 = left shift, 1 = arithmetic right shift
    // shift_amt: shift amount (1 or 8)
    function [63:0] shift_op;
        input [63:0] q_in;
        input        dir;
        input  [5:0] shift_amt;
        reg   [63:0] shifted;
        reg          sign_bit;
        integer      i;
        begin
            sign_bit = q_in[63];
            if (dir == 0) begin
                // Left shift by shift_amt, fill with zeros
                shifted = q_in << shift_amt;
            end else begin
                // Arithmetic right shift by shift_amt
                // Sign extend by replicating sign_bit
                shifted = q_in >> shift_amt;
                for (i = 63; i >= 64 - shift_amt; i = i -1) begin
                    shifted[i] = sign_bit;
                end
            end
            shift_op = shifted;
        end
    endfunction

    wire direction = amount[1];      // 0: left shift, 1: arithmetic right shift
    wire shift_by_8 = amount[0];     // 0: shift by 1, 1: shift by 8
    wire [5:0] shift_amount = shift_by_8 ? 6'd8 : 6'd1;

    wire [63:0] shifted_val = shift_op(q, direction, shift_amount);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted_val;
        end
        // else hold current q
    end

endmodule