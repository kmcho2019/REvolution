module TopModule (
    input [2:0] in,
    output reg [1:0] out
);
    reg [1:0] count;
    reg [1:0] bit_pos;
    
    always @(*) begin
        count = 2'b00;
        for (bit_pos = 0; bit_pos < 3; bit_pos = bit_pos + 1) begin
            if (in[bit_pos])
                count = count + 1;
        end
        out = count;
    end
endmodule