module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    if (|c[3:2]) begin  // Default case when c >= 4
        q = 4'b0000;    // Changed to all 0s for lower power
    end else begin
        case (c[1:0])
            2'b00: q = b;  // When c == 0
            2'b01: q = e;  // When c == 1
            2'b10: q = a;  // When c == 2
            2'b11: q = d;  // When c == 3
            default: q = 4'b0000;
        endcase
    end
end

endmodule