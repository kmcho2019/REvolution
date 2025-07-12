module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

wire [15:0] inputs [8:0];
assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = c;
assign inputs[3] = d;
assign inputs[4] = e;
assign inputs[5] = f;
assign inputs[6] = g;
assign inputs[7] = h;
assign inputs[8] = i;

always_comb begin
    case (sel)
        4'd0: out = a;
        4'd1: out = b;
        4'd2: out = c;
        4'd3: out = d;
        4'd4: out = e;
        4'd5: out = f;
        4'd6: out = g;
        4'd7: out = h;
        4'd8: out = i;
        default: out = {16{1'b1}};
    endcase
end

endmodule