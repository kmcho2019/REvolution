module TopModule(
    input  [3:0] x,
    output reg    f
);

wire x3 = x[3];
wire x2 = x[2];
wire x1 = x[1];
wire x0 = x[0];

// Factored main condition covering minterms with (~x3 & ~x1)
wire main_term = (~x3 & ~x1);

always @(*) begin
    // Start from main factored term
    f = main_term;

    // Override or set f for specific minterms not covered by main_term
    // These minterms: 
    // ( ~x3 & x2 & x1 & ~x0 ) -> 0110 (6 decimal)
    // ( x3 & x2 & (~x0 | (x1 & x0)) )
    // So handle these minterms explicitly
    case (x)
        4'b0110: f = 1'b1; // (~x3 & x2 & x1 & ~x0)
        4'b1100,       // x3 x2 x1 x0 = 1 1 0 0
        4'b1110,       // 1 1 1 0
        4'b1111:       // 1 1 1 1
            f = 1'b1;   // covers (x3 & x2 & (~x0 | (x1 & x0)))
        default:
            ; // no change, f remains as main_term
    endcase
end

endmodule