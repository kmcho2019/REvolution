module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q // Declare 'q' as a reg for procedural assignments
);

always @(*) begin
    case(c)
        4'b0000: q = b;
        4'b0001: q = e;
        4'b0010: q = a;
        4'b0011: q = d;
        default: q = 4'b1111; // Assign 'f' as 4'b1111 for c values greater than 3
    endcase
end

endmodule