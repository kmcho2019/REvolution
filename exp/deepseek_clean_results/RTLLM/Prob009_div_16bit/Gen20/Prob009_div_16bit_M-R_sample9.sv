module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate remainders
    wire [8:0] r15 = {8'b0, A[15]};
    wire [8:0] r14 = { (r15 >= B) ? (r15 - B) : r15, A[14] };
    wire [8:0] r13 = { (r14 >= B) ? (r14 - B) : r14, A[13] };
    wire [8:0] r12 = { (r13 >= B) ? (r13 - B) : r13, A[12] };
    wire [8:0] r11 = { (r12 >= B) ? (r12 - B) : r12, A[11] };
    wire [8:0] r10 = { (r11 >= B) ? (r11 - B) : r11, A[10] };
    wire [8:0] r9  = { (r10 >= B) ? (r10 - B) : r10, A[9]  };
    wire [8:0] r8  = { (r9  >= B) ? (r9  - B) : r9,  A[8]  };
    wire [8:0] r7  = { (r8  >= B) ? (r8  - B) : r8,  A[7]  };
    wire [8:0] r6  = { (r7  >= B) ? (r7  - B) : r7,  A[6]  };
    wire [8:0] r5  = { (r6  >= B) ? (r6  - B) : r6,  A[5]  };
    wire [8:0] r4  = { (r5  >= B) ? (r5  - B) : r5,  A[4]  };
    wire [8:0] r3  = { (r4  >= B) ? (r4  - B) : r4,  A[3]  };
    wire [8:0] r2  = { (r3  >= B) ? (r3  - B) : r3,  A[2]  };
    wire [8:0] r1  = { (r2  >= B) ? (r2  - B) : r2,  A[1]  };
    wire [8:0] r0  = { (r1  >= B) ? (r1  - B) : r1,  A[0]  };

    // Final remainder
    wire [7:0] final_remainder = (r0 >= B) ? (r0 - B) : r0;

    // Quotient bits
    assign result = {
        (r15 >= B),
        (r14 >= B),
        (r13 >= B),
        (r12 >= B),
        (r11 >= B),
        (r10 >= B),
        (r9  >= B),
        (r8  >= B),
        (r7  >= B),
        (r6  >= B),
        (r5  >= B),
        (r4  >= B),
        (r3  >= B),
        (r2  >= B),
        (r1  >= B),
        (r0  >= B)
    };

    assign odd = {8'b0, final_remainder};

endmodule