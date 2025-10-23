module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Create a 4-bit input vector for case statement
    wire [3:0] inputs = {a, b, c, d};
    
    // Implement the logic using a truth table approach
    always @(*) begin
        case(inputs)
            4'b0000: out = 1'b0;
            4'b0001: out = 1'b0;
            4'b0010: out = 1'b0;
            4'b0011: out = 1'b1;
            4'b0100: out = 1'b0;
            4'b0101: out = 1'b0;
            4'b0110: out = 1'b0;
            4'b0111: out = 1'b1;
            4'b1000: out = 1'b0;
            4'b1001: out = 1'b0;
            4'b1010: out = 1'b0;
            4'b1011: out = 1'b1;
            4'b1100: out = 1'b1;
            4'b1101: out = 1'b1;
            4'b1110: out = 1'b1;
            4'b1111: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
    
    // Generate inverted output
    assign out_n = ~out;
endmodule