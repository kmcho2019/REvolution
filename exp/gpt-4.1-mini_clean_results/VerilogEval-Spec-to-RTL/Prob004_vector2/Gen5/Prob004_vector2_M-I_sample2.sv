module TopModule(
    input          clk,
    input  [31:0]  in,
    output reg [31:0] out
);

reg [31:0] prev_in;

// Wire to hold reversed bytes
wire [31:0] reversed;
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : byte_reverse
        assign reversed[(i*8) +: 8] = in[((3 - i)*8) +: 8];
    end
endgenerate

always @(posedge clk) begin
    if (in != prev_in) begin
        out <= reversed;
        prev_in <= in;
    end
end

endmodule