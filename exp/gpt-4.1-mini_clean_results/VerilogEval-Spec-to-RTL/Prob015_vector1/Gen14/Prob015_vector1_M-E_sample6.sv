module TopModule (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);
    always @(*) begin
        // Mask and assign lower 8 bits
        out_lo = in & 16'h00FF;
        // Mask and shift upper 8 bits down to lower byte
        out_hi = (in & 16'hFF00) >> 8;
    end
endmodule