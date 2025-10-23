module adder_8bit(a, b, Cin, y, Co);
    input [7:0] a;
    input [7:0] b;
    input Cin;
    output [7:0] y;
    output Co;
    assign {Co, y} = a + b + Cin;
endmodule

module adder_16bit(a, b, Cin, y, Co);
    input [15:0] a;
    input [15:0] b;
    input Cin;
    output [15:0] y;
    output Co;
    wire Cmid;
    
    adder_8bit u_lower(a[7:0], b[7:0], Cin, y[7:0], Cmid);
    adder_8bit u_upper(a[15:8], b[15:8], Cmid, y[15:8], Co);
endmodule