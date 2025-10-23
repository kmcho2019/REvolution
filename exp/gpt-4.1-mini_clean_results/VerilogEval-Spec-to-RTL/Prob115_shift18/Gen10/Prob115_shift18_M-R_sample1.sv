module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg  [63:0] next_q;

    always @(*) begin
        case (amount)
            2'b00: next_q = q << 1;                               // shift left by 1
            2'b01: next_q = q << 8;                               // shift left by 8
            2'b10: next_q = {msb, q[63:1]};                       // arithmetic shift right by 1
            2'b11: next_q = {{8{msb}}, q[63:8]};                  // arithmetic shift right by 8
            default: next_q = q;                                  // default no shift (should never occur)
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= next_q;
    end

endmodule