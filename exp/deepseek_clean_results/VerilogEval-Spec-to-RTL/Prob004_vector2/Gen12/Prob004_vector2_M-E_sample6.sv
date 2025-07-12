module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    reg [31:0] reversed;
    reg [31:0] temp_in;
    integer i;
    
    always @(*) begin
        temp_in = in;
        reversed = 32'b0;
        
        for (i = 0; i < 4; i = i + 1) begin
            reversed = reversed << 8;
            reversed[7:0] = temp_in[31:24];
            temp_in = temp_in << 8;
        end
    end
    
    assign out = reversed;
endmodule