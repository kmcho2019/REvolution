module min2(
    input  [7:0] x,
    input  [7:0] y,
    output [7:0] z
);
    assign z = (x < y) ? x : y;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    output reg [7:0] min
);
    wire [7:0] min_ab, min_cd;

    // First layer: instantiate min2 modules to get min(a,b) and min(c,d)
    min2 u_min_ab (.x(a), .y(b), .z(min_ab));
    min2 u_min_cd (.x(c), .y(d), .z(min_cd));

    // Second layer: balanced final comparison done in combinational procedural block
    always @(*) begin
        min = (min_ab < min_cd) ? min_ab : min_cd;
    end

endmodule