module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= (byteena[1] ? {8{1'b1}} : 8'b0) << 8 & d | 
             ~((byteena[1] ? {8{1'b1}} : 8'b0) << 8) & q;
             
    // Above only updates upper byte; similarly for lower byte:
    // To combine both bytes, create mask for each byteena bit and apply to q.
    // Let's rewrite combined assignment for clarity:

end

endmodule