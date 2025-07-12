module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];
    reg  [63:0] shift_val;

    always @(*) begin
        case (amount)
            2'b00: shift_val = {q[62:0], 1'b0};            // shift left 1
            2'b01: shift_val = {q[55:0], 8'b0};            // shift left 8
            2'b10: shift_val = {sign, q[63:1]};            // shift right 1 (arith)
            2'b11: shift_val = {{8{sign}}, q[63:8]};       // shift right 8 (arith)
            default: shift_val = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_val;
    end

endmodule