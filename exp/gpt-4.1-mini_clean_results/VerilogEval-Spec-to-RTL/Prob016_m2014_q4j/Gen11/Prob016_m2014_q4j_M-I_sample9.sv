module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [4:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : full_adder_loop
            assign sum[i] = x[i] ^ y[i] ^ carry[i];
            assign carry[i+1] = (x[i] & y[i]) | (x[i] & carry[i]) | (y[i] & carry[i]);
        end
    endgenerate

    assign sum[4] = carry[4]; // overflow bit
endmodule