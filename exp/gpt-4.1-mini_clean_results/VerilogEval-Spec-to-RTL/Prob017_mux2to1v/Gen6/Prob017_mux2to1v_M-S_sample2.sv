module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output reg  [99:0] out
);
    always @(*) begin
        if (sel)
            out = b;
        else
            out = a;
    end
endmodule