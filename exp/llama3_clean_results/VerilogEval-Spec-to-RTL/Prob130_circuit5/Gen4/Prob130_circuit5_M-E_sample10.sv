module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c[1:0]) // Using only the lower 2 bits of 'c' for selection
        2'b00: q = b; // Select 'b' when 'c' is 0
        2'b01: q = e; // Select 'e' when 'c' is 1
        2'b10: q = a; // Select 'a' when 'c' is 2
        2'b11: q = d; // Select 'd' when 'c' is 3
        default: ; // This case is implicitly handled by the conditional statement below
    endcase
    
    // If 'c' is greater than 3, assign the default value 'f' to 'q'
    if (c > 4'd3) begin
        q = 4'b1111; // Assign 'f' to 'q' for 'c' values greater than 3
    end
end

endmodule