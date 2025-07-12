module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);

    always @* begin
        // Procedurally assign high and low bytes from input
        out_hi = in[15:8];
        out_lo = in[7:0];
    end

endmodule