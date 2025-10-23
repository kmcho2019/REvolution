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

// Use an array to hold the input signals for simplicity and potential area reduction
reg [15:0] inputs [8:0];
always @(*) begin
    inputs[0] = a;
    inputs[1] = b;
    inputs[2] = c;
    inputs[3] = d;
    inputs[4] = e;
    inputs[5] = f;
    inputs[6] = g;
    inputs[7] = h;
    inputs[8] = i;
end

// Use a case statement within an always block to select the output
reg [15:0] out_reg;
always @(*) begin
    case (sel)
        4'd0: out_reg = inputs[0];
        4'd1: out_reg = inputs[1];
        4'd2: out_reg = inputs[2];
        4'd3: out_reg = inputs[3];
        4'd4: out_reg = inputs[4];
        4'd5: out_reg = inputs[5];
        4'd6: out_reg = inputs[6];
        4'd7: out_reg = inputs[7];
        4'd8: out_reg = inputs[8];
        default: out_reg = 16'hFFFF;
    endcase
end

assign out = out_reg;

endmodule