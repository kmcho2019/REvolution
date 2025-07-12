module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Dynamic partial product generation with operand isolation
    wire [15:0] pp [7:0];
    assign pp[0] = B[0] ? {8'b0, A} : 16'b0;
    assign pp[1] = B[1] ? pp[0] + {7'b0, A, 1'b0} : pp[0];
    assign pp[2] = B[2] ? pp[1] + {6'b0, A, 2'b0} : pp[1];
    assign pp[3] = B[3] ? pp[2] + {5'b0, A, 3'b0} : pp[2];
    assign pp[4] = B[4] ? pp[3] + {4'b0, A, 4'b0} : pp[3];
    assign pp[5] = B[5] ? pp[4] + {3'b0, A, 5'b0} : pp[4];
    assign pp[6] = B[6] ? pp[5] + {2'b0, A, 6'b0} : pp[5];
    assign pp[7] = B[7] ? pp[6] + {1'b0, A, 7'b0} : pp[6];

    // 3:2 Carry-Save Adder stages
    wire [15:0] sum1, carry1;
    assign {carry1, sum1} = pp[0] + pp[1] + pp[2];
    
    wire [15:0] sum2, carry2;
    assign {carry2, sum2} = pp[3] + pp[4] + pp[5];
    
    wire [15:0] sum3, carry3;
    assign {carry3, sum3} = pp[6] + pp[7] + sum1;

    // Final Kogge-Stone adder
    wire [15:0] final_sum = sum2 + sum3;
    wire [15:0] final_carry = (carry1 << 1) + (carry2 << 1) + (carry3 << 1);
    
    assign product = final_sum + final_carry;

endmodule