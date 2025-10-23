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

    // Concatenate inputs into one large vector for direct indexing
    wire [16*9-1:0] inputs_concat;
    assign inputs_concat = {a, b, c, d, e, f, g, h, i};

    always @(*) begin
        case (sel)
            4'd0:  out = inputs_concat[16*9-1 -:16];
            4'd1:  out = inputs_concat[16*8-1 -:16];
            4'd2:  out = inputs_concat[16*7-1 -:16];
            4'd3:  out = inputs_concat[16*6-1 -:16];
            4'd4:  out = inputs_concat[16*5-1 -:16];
            4'd5:  out = inputs_concat[16*4-1 -:16];
            4'd6:  out = inputs_concat[16*3-1 -:16];
            4'd7:  out = inputs_concat[16*2-1 -:16];
            4'd8:  out = inputs_concat[16*1-1 -:16];
            default: out = 16'hFFFF;
        endcase
    end

endmodule