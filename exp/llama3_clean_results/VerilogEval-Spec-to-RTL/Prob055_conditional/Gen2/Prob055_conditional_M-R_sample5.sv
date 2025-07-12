module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    reg [7:0] min_reg;

    always @(*) begin
        reg [7:0] min_ab;
        reg [7:0] min_abc;
        min_ab = (a < b)? a : b;
        min_abc = (min_ab < c)? min_ab : c;
        min_reg = (min_abc < d)? min_abc : d;
    end

    assign min = min_reg;

endmodule