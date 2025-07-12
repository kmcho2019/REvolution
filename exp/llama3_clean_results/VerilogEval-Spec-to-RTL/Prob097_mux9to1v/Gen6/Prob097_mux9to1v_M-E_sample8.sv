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

reg [15:0] temp_out;

always @(*)
begin
    case(sel)
        4'd0: temp_out = a;
        4'd1: temp_out = b;
        4'd2: temp_out = c;
        4'd3: temp_out = d;
        4'd4: temp_out = e;
        4'd5: temp_out = f;
        4'd6: temp_out = g;
        4'd7: temp_out = h;
        4'd8: temp_out = i;
        default: temp_out = 16'b1111111111111111;
    endcase
end

assign out = temp_out;

endmodule