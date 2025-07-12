module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] c; // carry signals between stages

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : full_adder_block
            wire axb = x[i] ^ y[i];
            assign sum[i] = axb ^ (i == 0 ? 1'b0 : c[i-1]);
            wire aandb = x[i] & y[i];
            wire axb_and_cin = axb & (i == 0 ? 1'b0 : c[i-1]);
            assign c[i] = aandb | axb_and_cin;
        end
    endgenerate

    assign sum[4] = c[3]; // final carry-out as overflow bit

endmodule