module TopModule(
    input  [254:0] in,
    output [7:0] out
);

// Declare wires for the counts
wire [7:0] count_bytes [31:0];
wire [7:0] count_leftover;
wire [7:0] sum_bytes [4:0];

// Count the '1's in each byte
genvar i;
generate
    for (i = 0; i < 32; i++) begin
        // Count the '1's in each byte using a simple loop
        wire [7:0] count;
        reg [2:0] j;
        always @(in[i*8 +: 8]) begin
            count = 8'd0;
            for (j = 0; j < 8; j++) begin
                if (in[i*8 + j]) begin
                    count = count + 1'd1;
                end
            end
        end
        assign count_bytes[i] = count;
    end
endgenerate

// Count the '1's in the leftover bits
always @(in[254:248]) begin
    count_leftover = 8'd0;
    if (in[254]) count_leftover = count_leftover + 1'd1;
    if (in[253]) count_leftover = count_leftover + 1'd1;
    if (in[252]) count_leftover = count_leftover + 1'd1;
    if (in[251]) count_leftover = count_leftover + 1'd1;
    if (in[250]) count_leftover = count_leftover + 1'd1;
    if (in[249]) count_leftover = count_leftover + 1'd1;
    if (in[248]) count_leftover = count_leftover + 1'd1;
end

// Add up the counts from the bytes
assign sum_bytes[0] = count_bytes[0] + count_bytes[1];
assign sum_bytes[1] = count_bytes[2] + count_bytes[3];
assign sum_bytes[2] = count_bytes[4] + count_bytes[5];
assign sum_bytes[3] = count_bytes[6] + count_bytes[7];
assign sum_bytes[4] = count_bytes[8] + count_bytes[9] + count_bytes[10] + count_bytes[11] + 
                      count_bytes[12] + count_bytes[13] + count_bytes[14] + count_bytes[15];
assign sum_bytes[4] = sum_bytes[4] + count_bytes[16] + count_bytes[17] + count_bytes[18] + 
                      count_bytes[19] + count_bytes[20] + count_bytes[21] + count_bytes[22] + 
                      count_bytes[23] + count_bytes[24] + count_bytes[25] + count_bytes[26] + 
                      count_bytes[27] + count_bytes[28] + count_bytes[29] + count_bytes[30] + 
                      count_bytes[31] + count_leftover;

// Final sum
always @(sum_bytes[4]) begin
    out = sum_bytes[4];
end

endmodule