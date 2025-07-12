module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case(c[1:0]) // Use only the lower two bits of 'c' for the case statement
        2'b00: q = b;
        2'b01: q = e;
        2'b10: q = a;
        2'b11: q = d;
        default: ; // This will never occur since we're only using the lower two bits
    endcase
    
    if (c[3:2] != 2'b00) // Check if the higher two bits of 'c' are not zero
        q = 4'b1111; // If true, assign 'f' (4'b1111) to 'q'
end

endmodule