module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum01;
    wire [1:0] final_sum;

    assign sum01 = in[0] ^ in[1];          // sum bit of in[0] and in[1]
    assign final_sum[1] = in[0] & in[1];  // carry bit from first addition

    assign final_sum[0] = sum01 ^ in[2];                  // sum of previous sum and in[2]
    assign final_sum[1] = final_sum[1] | (sum01 & in[2]); // carry out from the last addition

    assign out = final_sum;

endmodule