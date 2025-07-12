module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Function to perform arithmetic shift based on amount and direction
    function [63:0] arithmetic_shift;
        input [63:0] value;
        input [1:0] amt;
        reg direction;      // 0 = left, 1 = right
        reg [5:0] shift_val;
        reg sign;
        begin
            direction = amt[1];
            shift_val = (amt[0]) ? 6'd8 : 6'd1;
            sign = value[63];
            if (direction == 1'b0) begin
                // Left shift
                arithmetic_shift = value << shift_val;
            end else begin
                // Arithmetic right shift with sign extension
                arithmetic_shift = (value >> shift_val) | ({64{sign}} << (64 - shift_val));
            end
        end
    endfunction

    wire [63:0] shifted_data = arithmetic_shift(q, amount);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted_data;
        end
        // else retain q
    end

endmodule