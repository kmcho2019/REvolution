module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    always_comb begin
        out = sel? b : a;
    end

endmodule