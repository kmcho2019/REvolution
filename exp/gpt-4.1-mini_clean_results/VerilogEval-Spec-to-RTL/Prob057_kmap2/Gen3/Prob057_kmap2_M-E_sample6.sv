module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Intermediate signals
wire na = ~a;
wire nb = ~b;

// Functions of a,b for each cd combination
wire f0 = na | nb;                       // cd=00
wire f1 = (na & nb) | (a & b);          // cd=01
wire f2 = na | nb;                       // cd=10
wire f3 = a | b;                        // cd=11

// Select lines combined as 2-bit index
wire [1:0] sel = {c,d};

reg out_reg;

always @(*) begin
    case(sel)
        2'b00: out_reg = f0;
        2'b01: out_reg = f1;
        2'b10: out_reg = f2;
        2'b11: out_reg = f3;
        default: out_reg = 1'b0;
    endcase
end

assign out = out_reg;

endmodule