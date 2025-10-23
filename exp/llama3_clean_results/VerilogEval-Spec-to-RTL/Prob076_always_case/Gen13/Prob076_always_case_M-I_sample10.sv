module TopModule #(
    parameter WIDTH = 4,
    parameter SEL_WIDTH = 3
)(
    input  [SEL_WIDTH-1:0] sel,
    input  [WIDTH-1:0] data0,
    input  [WIDTH-1:0] data1,
    input  [WIDTH-1:0] data2,
    input  [WIDTH-1:0] data3,
    input  [WIDTH-1:0] data4,
    input  [WIDTH-1:0] data5,
    output reg [WIDTH-1:0] out
);

always @(*) begin
    case (sel)
        3'b000: out = data0;
        3'b001: out = data1;
        3'b010: out = data2;
        3'b011: out = data3;
        3'b100: out = data4;
        3'b101: out = data5;
        default: out = {WIDTH{1'b0}};
    endcase
end

endmodule