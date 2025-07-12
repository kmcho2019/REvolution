module TopModule(
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire [15:0] c,
    input  wire [15:0] d,
    input  wire [15:0] e,
    input  wire [15:0] f,
    input  wire [15:0] g,
    input  wire [15:0] h,
    input  wire [15:0] i,
    input  wire [3:0] sel,
    output wire [15:0] out
);

assign out = (sel == 4'd0)? a :
             (sel == 4'd1)? b :
             (sel == 4'd2)? c :
             (sel == 4'd3)? d :
             (sel == 4'd4)? e :
             (sel == 4'd5)? f :
             (sel == 4'd6)? g :
             (sel == 4'd7)? h :
             (sel == 4'd8)? i :
             16'b1111111111111111;

endmodule