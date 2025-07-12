module TopModule(
    input  [2:0] in,
    output reg [1:0] out
);

always @(*) begin
    out = {1'b0, 1'b0}; // Initialize out to zero
    if(in[0]) out = out + 2'd1; // Count the least significant bit
    if(in[1]) out = out + 2'd1; // Count the middle bit
    if(in[2]) out = out + 2'd1; // Count the most significant bit
end

endmodule