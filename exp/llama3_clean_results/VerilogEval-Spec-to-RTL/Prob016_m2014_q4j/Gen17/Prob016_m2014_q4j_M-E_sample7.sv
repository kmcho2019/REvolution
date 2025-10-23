module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    reg [4:0] result;
    reg [3:0] carry;

    always @(*) begin
        result[0] = x[0] ^ y[0];
        carry[0] = x[0] & y[0];

        result[1] = x[1] ^ y[1] ^ carry[0];
        carry[1] = (x[1] & y[1]) | (x[1] & carry[0]) | (y[1] & carry[0]);

        result[2] = x[2] ^ y[2] ^ carry[1];
        carry[2] = (x[2] & y[2]) | (x[2] & carry[1]) | (y[2] & carry[1]);

        result[3] = x[3] ^ y[3] ^ carry[2];
        carry[3] = (x[3] & y[3]) | (x[3] & carry[2]) | (y[3] & carry[2]);

        sum[0] = result[0];
        sum[1] = result[1];
        sum[2] = result[2];
        sum[3] = result[3];
        sum[4] = carry[3];
    end

endmodule