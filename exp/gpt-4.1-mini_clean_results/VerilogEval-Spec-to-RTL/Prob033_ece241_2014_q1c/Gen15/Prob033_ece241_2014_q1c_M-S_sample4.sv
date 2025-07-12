module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] p;       // propagate = a ^ b
    wire [7:0] g;       // generate = a & b
    wire [8:0] c;       // carry signals, c[0] = 0 initial carry-in

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign s = p ^ c[7:0];
    assign overflow = c[7] ^ c[8];

endmodule