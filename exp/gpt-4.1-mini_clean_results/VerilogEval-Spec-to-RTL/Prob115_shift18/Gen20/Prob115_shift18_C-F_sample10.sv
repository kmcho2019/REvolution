module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Four possible shifts explicitly defined:
    // 00: shift left by 1
    wire [63:0] shift0 = {q[62:0], 1'b0};
    // 01: shift left by 8
    wire [63:0] shift1 = {q[55:0], 8'b0};
    // 10: arithmetic shift right by 1
    wire [63:0] shift2 = {msb, q[63:1]};
    // 11: arithmetic shift right by 8
    wire [63:0] shift3 = {{8{msb}}, q[63:8]};

    // Single 4-to-1 mux selecting shifted output by 'amount'
    wire [63:0] shifted = (amount == 2'b00) ? shift0 :
                         (amount == 2'b01) ? shift1 :
                         (amount == 2'b10) ? shift2 : shift3;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        // else hold (implicit, no need to assign)
    end

endmodule