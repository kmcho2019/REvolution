module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

reg [3:0] selected;

always @(*) begin
    case (c)
        4'd0: selected = b;
        4'd1: selected = e;
        4'd2: selected = a;
        4'd3: selected = d;
        default: selected = 4'hf; // 'f' for all other cases
    endcase
end

assign q = selected;

endmodule