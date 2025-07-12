module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg  [63:0] shift_val;

    always @(*) begin
        case (amount)
            2'b00: shift_val = {q[62:0], 1'b0};                 // shift left by 1
            2'b01: shift_val = {q[55:0], 8'b0};                 // shift left by 8
            2'b10: shift_val = {msb, q[63:1]};                  // arithmetic shift right by 1
            2'b11: shift_val = {{8{msb}}, q[63:8]};             // arithmetic shift right by 8
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