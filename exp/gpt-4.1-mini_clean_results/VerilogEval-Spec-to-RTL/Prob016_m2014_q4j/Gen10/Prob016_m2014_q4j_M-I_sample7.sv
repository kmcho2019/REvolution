module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [4:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : add_loop
            wire a = x[i];
            wire b = y[i];
            wire cin = carry[i];
            wire s;
            wire cout;

            assign s = a ^ b ^ cin;
            assign cout = (a & b) | (a & cin) | (b & cin);

            assign sum[i] = s;
            assign carry[i+1] = cout;
        end
    endgenerate

    assign sum[4] = carry[4];
endmodule