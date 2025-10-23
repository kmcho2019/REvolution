module TopModule(
    input  [255:0] in,
    output [7:0] out
);

// Count the number of '1's in each 8-bit segment
wire [31:0] count_8bit;
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin
        wire [7:0] segment = in[i*8 +: 8];
        wire [3:0] count;
        always @(segment) begin
            count = 4'b0;
            for (int j = 0; j < 8; j = j + 1) begin
                if (segment[j]) begin
                    count = count + 1;
                end
            end
        end
        assign count_8bit[i] = count;
    end
endgenerate

// Count the number of '1's in the resulting 32-bit count vector
wire [5:0] count_32bit;
always @(count_8bit) begin
    count_32bit = 6'b0;
    for (int i = 0; i < 32; i = i + 1) begin
        count_32bit = count_32bit + count_8bit[i];
    end
end

// Limit the output to 8 bits
assign out = count_32bit[5:0] + {2'b0, count_32bit[6]};

endmodule