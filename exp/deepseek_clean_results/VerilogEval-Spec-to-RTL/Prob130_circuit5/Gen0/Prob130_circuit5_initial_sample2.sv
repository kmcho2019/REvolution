module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c[1:0])  // Only look at the two LSBs of c
        2'b00: q = b;
        2'b01: q = e;
        2'b10: q = a;
        2'b11: q = d;
        default: q = 4'b0000;  // Default case (shouldn't occur since we cover all 2-bit combinations)
    endcase

    // Override with default value if c[3:2] is not zero
    if (|c[3:2]) begin
        q = 4'b0000;
    end
end

endmodule