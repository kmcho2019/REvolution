module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

reg [1:0] c_lower;

assign c_lower = c[1:0];

always @(*)
begin
    case(c_lower)
        2'b00: q = b;
        2'b01: q = e;
        2'b10: q = a;
        2'b11: q = d;
        default: q = 4'b1111;
    endcase
    
    if (c[3:2]!= 2'b00) 
        q = 4'b1111;
end

endmodule