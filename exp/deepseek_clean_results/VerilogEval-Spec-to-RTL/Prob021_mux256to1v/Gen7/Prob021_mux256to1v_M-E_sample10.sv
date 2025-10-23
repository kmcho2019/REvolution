module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output reg [3:0] out
);
    always @(*) begin
        out = 4'b0;  // Default assignment
        for (integer i = 0; i < 256; i = i + 1) begin
            if (sel == i) begin
                out = in[i*4 +: 4];
            end
        end
    end
endmodule