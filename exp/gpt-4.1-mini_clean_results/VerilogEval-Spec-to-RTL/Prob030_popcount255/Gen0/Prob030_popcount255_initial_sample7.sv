module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Intermediate sums of bits
    // Step 1: Sum bits in groups of 8 for simpler reduction (last group has 7 bits)
    wire [3:0] sum8 [31:0]; // 32 groups of up to 8 bits (except last one with 7 bits)
    
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin : bit_groups
            // Sum 8 bits using builtin + operator on bits
            assign sum8[i] = in[i*8 +: 8];
        end
        // Last group has only 7 bits
        assign sum8[31] = in[31*8 +: 7];
    endgenerate

    // Step 2: Sum all partial sums into a single 8-bit sum
    // Because sum8 elements are 4 bits wide max (0 to 8),
    // sum of 32 such elements can be up to 32*8=256 which fits in 9 bits
    reg [8:0] total;
    integer j;
    always @* begin
        total = 0;
        for (j = 0; j < 32; j = j + 1) begin
            total = total + sum8[j];
        end
    end

    assign out = total[7:0]; // lower 8 bits as output, 255 fits in 8 bits

endmodule