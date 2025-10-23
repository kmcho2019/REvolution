module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output reg [15:0] out
);

wire [15:0] inputs [0:8];
assign inputs[0] = a;
assign inputs[1] = b;
assign inputs[2] = c;
assign inputs[3] = d;
assign inputs[4] = e;
assign inputs[5] = f;
assign inputs[6] = g;
assign inputs[7] = h;
assign inputs[8] = i;

always @(*) begin
    case (sel)
        4'd0: out = inputs[0];
        4'd1: out = inputs[1];
        4'd2: out = inputs[2];
        4'd3: out = inputs[3];
        4'd4: out = inputs[4];
        4'd5: out = inputs[5];
        4'd6: out = inputs[6];
        4'd7: out = inputs[7];
        4'd8: out = inputs[8];
        default: out = 16'hFFFF;
    endcase
end

endmodule