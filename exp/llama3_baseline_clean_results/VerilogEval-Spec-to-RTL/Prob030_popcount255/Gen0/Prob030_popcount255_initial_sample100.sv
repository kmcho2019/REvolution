module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Calculate population count for each 16-bit chunk
reg [4:0] count [15:0];

// Calculate population count for each 16-bit chunk
always @(in) begin
    for (int i = 0; i < 15; i++) begin
        count[i] = {in[(i+1)*16-1], in[(i+1)*16-2], in[(i+1)*16-3], in[(i+1)*16-4], in[(i+1)*16-5]};
        count[i] = (count[i] & 5'b10000) + (count[i] & 5'b01000) + (count[i] & 5'b00100) + (count[i] & 5'b00010) + (count[i] & 5'b00001);
    end
    count[15] = {in[254], in[253], in[252], in[251], in[250]};
    count[15] = (count[15] & 5'b10000) + (count[15] & 5'b01000) + (count[15] & 5'b00100) + (count[15] & 5'b00010) + (count[15] & 5'b00001);
    for (int i = 1; i < 16; i++) begin
        count[15] = count[15] + count[i-1];
    end
    out = count[15][7:0];
end

endmodule