module TopModule #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  sel_b1,
    input  sel_b2,
    output [WIDTH-1:0] out_assign,
    output reg [WIDTH-1:0] out_always
);

assign out_assign = (sel_b1 && sel_b2) ? b : a;

always @(*) begin
    out_always = (sel_b1 && sel_b2) ? b : a;
end

endmodule