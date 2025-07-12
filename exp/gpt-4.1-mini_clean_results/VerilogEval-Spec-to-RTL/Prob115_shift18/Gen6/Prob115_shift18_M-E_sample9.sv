module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg [63:0] shifted;

    always @(*) begin
        case (amount)
            2'b00: // shift left by 1
                shifted = q << 1;
            2'b01: // shift left by 8
                shifted = q << 8;
            2'b10: // arithmetic shift right by 1
                shifted = {msb, q[63:1]};
            2'b11: // arithmetic shift right by 8
                shifted = {{8{msb}}, q[63:8]};
            default:
                shifted = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule