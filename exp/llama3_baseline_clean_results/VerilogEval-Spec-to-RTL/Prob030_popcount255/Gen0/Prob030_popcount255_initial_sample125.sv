module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    wire [7:0]  count_2bit  [127:0];
    wire [7:0]  count_4bit  [63:0];
    wire [7:0]  count_8bit  [31:0];
    wire [7:0]  count_16bit [15:0];
    wire [7:0]  count_32bit [7:0];
    wire [7:0]  count_64bit [3:0];
    wire [7:0]  count_128bit [1:0];

    // Count 1's in 2-bit groups
    genvar i;
    generate
        for (i = 0; i < 128; i++) begin
            always @(in)
                count_2bit[i] = {in[2*i+1] ? 1 : 0, in[2*i] ? 1 : 0};
        end
    endgenerate

    // Count 1's in 4-bit groups
    generate
        for (i = 0; i < 64; i++) begin
            always @(count_2bit)
                count_4bit[i] = count_2bit[2*i] + count_2bit[2*i+1];
        end
    endgenerate

    // Count 1's in 8-bit groups
    generate
        for (i = 0; i < 32; i++) begin
            always @(count_4bit)
                count_8bit[i] = count_4bit[2*i] + count_4bit[2*i+1];
        end
    endgenerate

    // Count 1's in 16-bit groups
    generate
        for (i = 0; i < 16; i++) begin
            always @(count_8bit)
                count_16bit[i] = count_8bit[2*i] + count_8bit[2*i+1];
        end
    endgenerate

    // Count 1's in 32-bit groups
    generate
        for (i = 0; i < 8; i++) begin
            always @(count_16bit)
                count_32bit[i] = count_16bit[2*i] + count_16bit[2*i+1];
        end
    endgenerate

    // Count 1's in 64-bit groups
    generate
        for (i = 0; i < 4; i++) begin
            always @(count_32bit)
                count_64bit[i] = count_32bit[2*i] + count_32bit[2*i+1];
        end
    endgenerate

    // Count 1's in 128-bit groups
    generate
        for (i = 0; i < 2; i++) begin
            always @(count_64bit)
                count_128bit[i] = count_64bit[2*i] + count_64bit[2*i+1];
        end
    endgenerate

    // Final count
    always @(count_128bit)
        out = count_128bit[0] + count_128bit[1];

endmodule