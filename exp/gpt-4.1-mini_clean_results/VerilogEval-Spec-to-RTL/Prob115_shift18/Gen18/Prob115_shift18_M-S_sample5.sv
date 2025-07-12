module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire sign = q[63];

    wire [63:0] left1  = {q[62:0], 1'b0};
    wire [63:0] left8  = {q[55:0], 8'b0};
    wire [63:0] right1 = {sign, q[63:1]};
    wire [63:0] right8 = {{8{sign}}, q[63:8]};

    reg [63:0] shifted;

    always @(*) begin
        case(amount)
            2'b00: shifted = left1;
            2'b01: shifted = left8;
            2'b10: shifted = right1;
            2'b11: shifted = right8;
            default: shifted = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
    end

endmodule