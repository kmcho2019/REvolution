module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Combine inputs into a 4-bit vector
    wire [3:0] inputs = {a, b, c, d};
    
    always @(*) begin
        case (inputs)
            // Cases where (a&b) is true
            4'b1100, 4'b1101, 4'b1110, 4'b1111,
            // Cases where (c&d) is true
            4'b0011, 4'b0111, 4'b1011, 4'b1111: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
    
    assign out_n = ~out;
endmodule