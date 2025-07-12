module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline stages
    reg [1:0] stage;
    localparam STAGE_BOOTH = 2'b00;
    localparam STAGE_PARTIAL = 2'b01;
    localparam STAGE_REDUCE = 2'b10;
    localparam STAGE_DONE = 2'b11;

    // Booth encoding signals
    reg [9:0] multiplier_reg;  // Extended multiplier with prev bit
    wire [2:0] booth_bits [0:3];
    reg [7:0] multiplicand_reg;
    reg [15:0] multiplicand_ext;

    // Partial products
    reg [15:0] pp [0:3];
    wire [15:0] pp_neg = ~multiplicand_ext + 1;
    wire [15:0] pp_2x = {multiplicand_ext[14:0], 1'b0};
    wire [15:0] pp_neg2x = ~pp_2x + 1;

    // Wallace tree signals
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    wire [15:0] final_sum;

    // Booth encoding for each group
    assign booth_bits[0] = multiplier_reg[2:0];
    assign booth_bits[1] = multiplier_reg[4:2];
    assign booth_bits[2] = multiplier_reg[6:4];
    assign booth_bits[3] = multiplier_reg[8:6];

    // Partial product selection
    always @(*) begin
        for (integer i = 0; i < 4; i = i + 1) begin
            case (booth_bits[i])
                3'b000, 3'b111: pp[i] = 16'b0;
                3'b001, 3'b010: pp[i] = multiplicand_ext;
                3'b011: pp[i] = pp_2x;
                3'b100: pp[i] = pp_neg2x;
                3'b101, 3'b110: pp[i] = pp_neg;
                default: pp[i] = 16'b0;
            endcase
        end
    end

    // First level 4:2 compressor
    compressor_4to2 comp1 (
        .a(pp[0]), .b(pp[1]), .c(pp[2]), .d(pp[3]),
        .sum(sum1), .carry(carry1)
    );

    // Second level 4:2 compressor (for carries)
    compressor_4to2 comp2 (
        .a(sum1), .b(carry1 << 1), .c(16'b0), .d(16'b0),
        .sum(sum2), .carry(carry2)
    );

    // Final adder
    assign final_sum = sum2 + (carry2 << 1);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage <= STAGE_BOOTH;
            multiplicand_reg <= a;
            multiplier_reg <= {b[7], b, 1'b0};
            multiplicand_ext <= {{8{a[7]}}, a};
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            case (stage)
                STAGE_BOOTH: begin
                    stage <= STAGE_PARTIAL;
                    rdy <= 1'b0;
                end
                
                STAGE_PARTIAL: begin
                    stage <= STAGE_REDUCE;
                end
                
                STAGE_REDUCE: begin
                    p <= final_sum;
                    rdy <= 1'b1;
                    stage <= STAGE_DONE;
                end
                
                STAGE_DONE: begin
                    rdy <= 1'b0;
                    stage <= STAGE_BOOTH;
                end
            endcase
        end
    end

endmodule

// 4:2 compressor module for Wallace tree
module compressor_4to2 (
    input [15:0] a, b, c, d,
    output [15:0] sum, carry
);
    // Implementation of 4:2 compressor using full adders
    wire [15:0] s1, c1;
    wire [15:0] s2, c2;
    
    // First level of compression
    assign s1 = a ^ b ^ c;
    assign c1 = ((a & b) | (a & c) | (b & c)) << 1;
    
    // Second level of compression
    assign sum = s1 ^ d ^ c1;
    assign carry = ((s1 & d) | (s1 & c1) | (d & c1)) << 1;
endmodule