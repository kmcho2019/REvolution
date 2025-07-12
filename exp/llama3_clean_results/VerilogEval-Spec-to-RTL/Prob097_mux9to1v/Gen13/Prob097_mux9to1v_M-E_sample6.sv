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
    output reg [15:0] out
);

reg [15:0] mid1, mid2;

always @(*) begin
    // Select between first four and next four inputs
    mid1 = (sel[3] == 0)? (sel[2] == 0? (sel[1] == 0? (sel[0] == 0? a : b) : (sel[0] == 0? c : d)) : (sel[1] == 0? (sel[0] == 0? e : f) : (sel[0] == 0? g : h))) : i;
    
    // Handle unused cases
    out = (sel < 9)? mid1 : {16{1'b1}};
end

endmodule