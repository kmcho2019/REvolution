module TopModule (
    input in,
    output reg out
);
    // Implement NOT function using a LUT approach
    always @(*) begin
        case (in)
            1'b0: out = 1'b1;  // NOT(0) = 1
            1'b1: out = 1'b0;  // NOT(1) = 0
            default: out = 1'bx; // Handle undefined cases
        endcase
    end
endmodule