module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

wire [15:0] mask_upper = {8{byteena[1]}};
wire [15:0] mask_lower = {8{byteena[0]}};
wire [15:0] mask = (mask_upper << 8) | mask_lower;

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= (q & ~mask) | (d & mask);
end

endmodule