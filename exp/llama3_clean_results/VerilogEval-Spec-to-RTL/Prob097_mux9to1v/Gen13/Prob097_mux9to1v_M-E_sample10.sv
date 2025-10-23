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

reg [15:0] out_temp;

integer i;
always @(*) begin
    out_temp = 16'b0;
    for (i = 0; i < 16; i++) begin
        if (sel < 9) begin
            out_temp[i] = inputs[sel][i];
        end else begin
            out_temp[i] = 1'b1;
        end
    end
end

assign out = out_temp;

endmodule