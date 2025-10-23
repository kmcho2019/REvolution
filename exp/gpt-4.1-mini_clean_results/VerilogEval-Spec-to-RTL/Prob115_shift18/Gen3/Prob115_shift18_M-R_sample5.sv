module TopModule(
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Function to perform the shift operation based on amount input
    function [63:0] shift_op;
        input [63:0] value;
        input [1:0]  amt;
        begin
            case (amt)
                2'b00: shift_op = value << 1;                     // shift left by 1
                2'b01: shift_op = value << 8;                     // shift left by 8
                2'b10: shift_op = $signed(value) >>> 1;           // arithmetic shift right by 1
                2'b11: shift_op = $signed(value) >>> 8;           // arithmetic shift right by 8
                default: shift_op = value;
            endcase
        end
    endfunction

    wire [63:0] shifted = shift_op(q, amount);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
    end

endmodule