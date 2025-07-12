module TopModule (
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

    // Combined input as a 4-bit value for case statement
    wire [3:0] inputs = {a, b, c, d};

    // Sum-of-products implementation using case statement
    always @(*) begin
        case (inputs)
            4'b0010: out_sop = 1'b1;  // 2
            4'b0111: out_sop = 1'b1;  // 7
            4'b1111: out_sop = 1'b1;  // 15
            default: out_sop = 1'b0;   // All other cases (including don't-cares)
        endcase
    end

    // Product-of-sums implementation using case statement
    always @(*) begin
        case (inputs)
            4'b0000,  // 0
            4'b0001,  // 1
            4'b0100,  // 4
            4'b0101,  // 5
            4'b0110,  // 6
            4'b1001,  // 9
            4'b1010,  // 10
            4'b1101,  // 13
            4'b1110:  // 14
                out_pos = 1'b0;
            default: out_pos = 1'b1;  // All other cases (including don't-cares)
        endcase
    end

endmodule