module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    reg [31:0] reversed;
    integer i;
    
    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            reversed[8*i +: 8] = in[8*(3-i) +: 8];
        end
    end
    
    assign out = reversed;
endmodule