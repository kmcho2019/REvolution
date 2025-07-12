module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate remainder wires for each bit position
    wire [8:0] rem_15 = {8'b0, A[15]};
    wire [8:0] rem_14 = { (rem_15 >= B) ? (rem_15 - B) : rem_15, A[14] };
    wire [8:0] rem_13 = { (rem_14 >= B) ? (rem_14 - B) : rem_14, A[13] };
    wire [8:0] rem_12 = { (rem_13 >= B) ? (rem_13 - B) : rem_13, A[12] };
    wire [8:0] rem_11 = { (rem_12 >= B) ? (rem_12 - B) : rem_12, A[11] };
    wire [8:0] rem_10 = { (rem_11 >= B) ? (rem_11 - B) : rem_11, A[10] };
    wire [8:0] rem_9  = { (rem_10 >= B) ? (rem_10 - B) : rem_10, A[9]  };
    wire [8:0] rem_8  = { (rem_9  >= B) ? (rem_9  - B) : rem_9,  A[8]  };
    wire [8:0] rem_7  = { (rem_8  >= B) ? (rem_8  - B) : rem_8,  A[7]  };
    wire [8:0] rem_6  = { (rem_7  >= B) ? (rem_7  - B) : rem_7,  A[6]  };
    wire [8:0] rem_5  = { (rem_6  >= B) ? (rem_6  - B) : rem_6,  A[5]  };
    wire [8:0] rem_4  = { (rem_5  >= B) ? (rem_5  - B) : rem_5,  A[4]  };
    wire [8:0] rem_3  = { (rem_4  >= B) ? (rem_4  - B) : rem_4,  A[3]  };
    wire [8:0] rem_2  = { (rem_3  >= B) ? (rem_3  - B) : rem_3,  A[2]  };
    wire [8:0] rem_1  = { (rem_2  >= B) ? (rem_2  - B) : rem_2,  A[1]  };
    wire [8:0] rem_0  = { (rem_1  >= B) ? (rem_1  - B) : rem_1,  A[0]  };

    // Quotient bits
    assign result[15] = (rem_15 >= B);
    assign result[14] = (rem_14 >= B);
    assign result[13] = (rem_13 >= B);
    assign result[12] = (rem_12 >= B);
    assign result[11] = (rem_11 >= B);
    assign result[10] = (rem_10 >= B);
    assign result[9]  = (rem_9  >= B);
    assign result[8]  = (rem_8  >= B);
    assign result[7]  = (rem_7  >= B);
    assign result[6]  = (rem_6  >= B);
    assign result[5]  = (rem_5  >= B);
    assign result[4]  = (rem_4  >= B);
    assign result[3]  = (rem_3  >= B);
    assign result[2]  = (rem_2  >= B);
    assign result[1]  = (rem_1  >= B);
    assign result[0]  = (rem_0  >= B);

    // Final remainder
    assign odd = {8'b0, (rem_0 >= B) ? (rem_0 - B) : rem_0};

endmodule