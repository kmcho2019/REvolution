module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products with systematic shifting
    wire [15:0] pp [7:0];
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = ({ {8-i{1'b0}}, A, {i{1'b0}} }) & {16{B[i]}};
        end
    endgenerate

    // First level CSA reductions
    wire [15:0] sum1 = pp[0] ^ pp[1] ^ pp[2];
    wire [15:0] carry1 = (pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2]);
    
    wire [15:0] sum2 = pp[3] ^ pp[4] ^ pp[5];
    wire [15:0] carry2 = (pp[3] & pp[4]) | (pp[3] & pp[5]) | (pp[4] & pp[5]);

    // Second level CSA reduction
    wire [15:0] sum3 = sum1 ^ {carry1[14:0], 1'b0} ^ sum2;
    wire [15:0] carry3 = (sum1 & {carry1[14:0], 1'b0}) | 
                        (sum1 & sum2) | 
                        ({carry1[14:0], 1'b0} & sum2);

    // Third level CSA reduction
    wire [15:0] sum4 = sum3 ^ {carry3[14:0], 1'b0} ^ {carry2[14:0], 1'b0};
    wire [15:0] carry4 = (sum3 & {carry3[14:0], 1'b0}) | 
                        (sum3 & {carry2[14:0], 1'b0}) | 
                        ({carry3[14:0], 1'b0} & {carry2[14:0], 1'b0});

    // Final addition in two steps for better timing
    wire [15:0] partial_sum = sum4 + {carry4[14:0], 1'b0};
    assign product = partial_sum + pp[6] + pp[7];

endmodule