module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    always @(*)
    begin
        for (int i = 0; i < 8; i++)
        begin
            out[i] = sel ? b[i] : a[i];
        end
    end

endmodule