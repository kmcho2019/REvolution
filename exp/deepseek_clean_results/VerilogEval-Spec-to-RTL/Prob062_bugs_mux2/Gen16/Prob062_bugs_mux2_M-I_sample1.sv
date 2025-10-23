module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

    always @(*) begin
        out = (a & {8{~sel}}) | (b & {8{sel}});
    end

endmodule