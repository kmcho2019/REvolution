module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] carry;
    genvar i;

    // First bit full adder: carry in = 0
    assign sum[0] = x[0] ^ y[0];
    assign carry[0] = x[0] & y[0];

    generate
        for (i = 1; i < 4; i = i + 1) begin : adder_loop
            wire partial_sum = x[i] ^ y[i];
            assign sum[i] = partial_sum ^ carry[i-1];
            assign carry[i] = (x[i] & y[i]) | (partial_sum & carry[i-1]);
        end
    endgenerate

    // Assign final carry out as the MSB of sum
    assign sum[4] = carry[3];
endmodule