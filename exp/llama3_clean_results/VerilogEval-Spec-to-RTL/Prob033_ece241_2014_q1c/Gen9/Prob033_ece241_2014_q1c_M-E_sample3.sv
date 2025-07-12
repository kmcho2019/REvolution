module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);

    // Internal wires for CSA stages
    wire [7:0] sum_csa;
    wire [7:0] carry_csa;

    // CSA tree
    // Stage 1: Add a and b
    assign sum_csa = a ^ b;
    assign carry_csa = a & b;

    // Final adder stage
    wire [8:0] final_sum;
    assign final_sum = {1'b0, sum_csa} + {8'b0, carry_csa};

    // Assign outputs
    assign s = final_sum[7:0];
    assign overflow = final_sum[8];

endmodule