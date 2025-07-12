module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Function to perform the shift operation given the input value
    function [63:0] shift_arith;
        input [63:0] val;
        input        dir_right;   // 0 = left shift, 1 = arithmetic right shift
        input        shift_8;     // 0 = shift by 1, 1 = shift by 8
        reg   [63:0] left_shift_1;
        reg   [63:0] left_shift_8;
        reg   [63:0] right_shift_1;
        reg   [63:0] right_shift_8;
        begin
            // Left shift by 1 or 8 bits
            left_shift_1 = {val[62:0], 1'b0};
            left_shift_8 = {val[55:0], 8'd0};

            // Arithmetic right shift by 1 or 8 bits with sign extension
            right_shift_1 = {val[63], val[63:1]};
            right_shift_8 = {{8{val[63]}}, val[63:8]};

            if (dir_right) begin
                // Arithmetic right shift
                if (shift_8)
                    shift_arith = right_shift_8;
                else
                    shift_arith = right_shift_1;
            end else begin
                // Left shift
                if (shift_8)
                    shift_arith = left_shift_8;
                else
                    shift_arith = left_shift_1;
            end
        end
    endfunction

    wire dir_right = amount[1];
    wire shift_8  = amount[0];

    wire [63:0] shifted_val = shift_arith(q, dir_right, shift_8);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted_val;
        // else hold q
    end

endmodule