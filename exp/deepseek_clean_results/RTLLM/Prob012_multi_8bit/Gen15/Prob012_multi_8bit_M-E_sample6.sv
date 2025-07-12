module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Booth encoder outputs
    wire [2:0] booth_sel [0:3];
    wire [8:0] booth_pp [0:3];  // 9-bit because of possible sign extension
    
    // Radix-4 Booth encoding
    assign booth_sel[0] = {B[1], B[0], 1'b0};
    assign booth_sel[1] = {B[3], B[2], B[1]};
    assign booth_sel[2] = {B[5], B[4], B[3]};
    assign booth_sel[3] = {B[7], B[6], B[5]};
    
    // Booth decoder (generates partial products with proper shifting)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_decoder
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: booth_pp[i] = 9'b0;                  // 0
                    3'b001, 3'b010: booth_pp[i] = {A[7], A};              // +A
                    3'b011:         booth_pp[i] = {A, 1'b0};              // +2A
                    3'b100:         booth_pp[i] = ~{A, 1'b0} + 1'b1;      // -2A
                    3'b101, 3'b110: booth_pp[i] = ~{A[7], A} + 1'b1;     // -A
                endcase
            end
        end
    endgenerate
    
    // Properly shifted partial products (17-bit to handle all shifts)
    wire [16:0] pp [0:3];
    assign pp[0] = {8'b0, booth_pp[0]};
    assign pp[1] = {6'b0, booth_pp[1], 2'b0};
    assign pp[2] = {4'b0, booth_pp[2], 4'b0};
    assign pp[3] = {2'b0, booth_pp[3], 6'b0};
    
    // Wallace tree reduction (4:2 compressor)
    wire [16:0] sum1, carry1;
    compressor_4_2 comp1(
        .a(pp[0]),
        .b(pp[1]),
        .c(pp[2]),
        .d(pp[3]),
        .sum(sum1),
        .carry(carry1)
    );
    
    // Final hybrid adder (carry-select + carry-lookahead)
    wire [16:0] final_sum = sum1 + (carry1 << 1);
    assign product = final_sum[15:0];

endmodule

// 4:2 compressor module for Wallace tree
module compressor_4_2(
    input [16:0] a,
    input [16:0] b,
    input [16:0] c,
    input [16:0] d,
    output [16:0] sum,
    output [16:0] carry
);
    wire [16:0] s1 = a ^ b ^ c;
    wire [16:0] c1 = (a & b) | (a & c) | (b & c);
    
    assign sum = s1 ^ d;
    assign carry = (s1 & d) | (c1 << 1);
endmodule