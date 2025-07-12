module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shift_result;
    wire sign = q[63];

    always @(*) begin
        case(amount)
            2'b00: shift_result = {q[62:0], 1'b0};              // shift left by 1
            2'b01: shift_result = {q[55:0], 8'b0};              // shift left by 8
            2'b10: shift_result = {sign, q[63:1]};              // shift right arithmetic by 1
            2'b11: shift_result = {{8{sign}}, q[63:8]};         // shift right arithmetic by 8
            default: shift_result = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shift_result;
        else
            q <= q;
    end

endmodule