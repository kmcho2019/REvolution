module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [15:0] product_reg;
    reg [8:0] multiplier_reg;  // Extended with LSB for Booth
    reg [15:0] multiplicand_reg;
    reg [3:0] booth_sel [0:3];
    reg [15:0] partial_products [0:3];
    wire early_terminate;

    // Booth group definitions
    localparam GROUP0 = 2'b00;
    localparam GROUP1 = 2'b01;
    localparam GROUP2 = 2'b10;
    localparam GROUP3 = 2'b11;

    // Early termination detection
    assign early_terminate = (b == 8'b0) || (a == 8'b0);

    // Booth encoding for each group
    always @(*) begin
        booth_sel[GROUP0] = multiplier_reg[2:0];
        booth_sel[GROUP1] = multiplier_reg[4:2];
        booth_sel[GROUP2] = multiplier_reg[6:4];
        booth_sel[GROUP3] = multiplier_reg[8:6];
    end

    // Partial product generation
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : pp_gen
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: partial_products[i] = 16'b0;
                    3'b001, 3'b010: partial_products[i] = multiplicand_reg;
                    3'b011: partial_products[i] = multiplicand_reg << 1;
                    3'b100: partial_products[i] = ~(multiplicand_reg << 1) + 1;
                    3'b101, 3'b110: partial_products[i] = ~multiplicand_reg + 1;
                    default: partial_products[i] = 16'b0;
                endcase
            end
        end
    endgenerate

    // Partial product alignment and reduction
    wire [15:0] pp0_aligned = partial_products[GROUP0];
    wire [15:0] pp1_aligned = partial_products[GROUP1] << 2;
    wire [15:0] pp2_aligned = partial_products[GROUP2] << 4;
    wire [15:0] pp3_aligned = partial_products[GROUP3] << 6;

    // First level compression (4:2)
    wire [15:0] sum1, carry1;
    compressor_4to2 first_compressor (
        .a(pp0_aligned), .b(pp1_aligned), 
        .c(pp2_aligned), .d(pp3_aligned),
        .sum(sum1), .carry(carry1)
    );

    // Second level compression (carry-save adder)
    wire [15:0] sum2, carry2;
    assign sum2 = sum1 ^ (carry1 << 1);
    assign carry2 = (sum1 & (carry1 << 1)) << 1;

    // Final addition
    wire [15:0] final_sum = sum2 + carry2;

    // Control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand_reg <= {{8{a[7]}}, a};
            multiplier_reg <= {b, 1'b0};  // Append 0 for initial Booth group
            product_reg <= 16'b0;
            rdy <= 1'b0;
        end else begin
            if (early_terminate) begin
                product_reg <= 16'b0;
                rdy <= 1'b1;
            end else begin
                product_reg <= final_sum;
                rdy <= 1'b1;
            end
        end
    end

    // Output assignment
    always @(*) begin
        p = product_reg;
    end

endmodule

// Optimized 4:2 compressor using XOR/MAJ gates
module compressor_4to2 (
    input [15:0] a, b, c, d,
    output [15:0] sum, carry
);
    wire [15:0] xor_ab = a ^ b;
    wire [15:0] xor_cd = c ^ d;
    wire [15:0] maj_ab = (a & b) | (a & c) | (b & c);
    wire [15:0] maj_cd = (c & d) | (c & a) | (d & a);
    
    assign sum = xor_ab ^ xor_cd;
    assign carry = (maj_ab | maj_cd) << 1;
endmodule