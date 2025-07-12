module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    reg [15:0] tmp;

    always @* begin
        tmp = in;
        out_hi = tmp[15:8];
        out_lo = tmp[7:0];
    end

endmodule