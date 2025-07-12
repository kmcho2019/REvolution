module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z
);
    // LUT-based implementation using case statement
    // Treats {A,B} as address, implements truth table
    always @(*) begin
        case ({A, B})
            4'b0000,  // A=00, B=00
            4'b0101,  // A=01, B=01
            4'b1010,  // A=10, B=10
            4'b1111:  // A=11, B=11
                z = 1'b1;
            default:
                z = 1'b0;
        endcase
    end
    
    /* Alternative implementation note:
     * Could also be written as:
     * always @(*) z = (A == B);
     * but this case statement shows the explicit truth table
     */
endmodule