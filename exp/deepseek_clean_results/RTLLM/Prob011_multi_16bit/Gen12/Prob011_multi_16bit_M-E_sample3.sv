module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Pipeline stages
    reg [1:0] stage;
    reg [15:0] a_reg, b_reg;
    wire [31:0] product;

    // Booth encoder outputs
    wire [8:0][31:0] pp;  // Partial products
    wire [8:0] sign;       // Partial product signs

    // Wallace tree signals
    wire [31:0] s1, c1;    // Stage 1 sums/carries
    wire [31:0] s2, c2;    // Stage 2 sums/carries
    wire [31:0] s3, c3;    // Stage 3 sums/carries

    // Booth encoding and partial product generation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : booth
            wire [2:0] booth_bits = (i == 0) ? {b_reg[1:0], 1'b0} : b_reg[2*i+1:2*i-1];
            
            always @(*) begin
                case (booth_bits)
                    3'b000, 3'b111: begin pp[i] = 32'b0; sign[i] = 1'b0; end
                    3'b001, 3'b010: begin pp[i] = {16'b0, a_reg} << (2*i); sign[i] = 1'b0; end
                    3'b011:         begin pp[i] = {15'b0, a_reg, 1'b0} << (2*i); sign[i] = 1'b0; end
                    3'b100:         begin pp[i] = {15'b0, a_reg, 1'b0} << (2*i); sign[i] = 1'b1; end
                    3'b101, 3'b110: begin pp[i] = {16'b0, a_reg} << (2*i); sign[i] = 1'b1; end
                endcase
            end
        end
    endgenerate

    // Wallace tree reduction (4:2 compressors)
    // Stage 1: Reduce 9 partial products to 6
    compressor_4to2 comp1_0 (pp[0], pp[1], pp[2], pp[3], s1, c1);
    compressor_4to2 comp1_1 (pp[4], pp[5], pp[6], pp[7], s1, c1);
    
    // Stage 2: Reduce 6 to 4
    compressor_4to2 comp2_0 (s1[31:0], c1[31:0], pp[8], 32'b0, s2, c2);
    
    // Stage 3: Reduce 4 to 2
    compressor_4to2 comp3_0 (s2[31:0], c2[31:0], s1[63:32], c1[63:32], s3, c3);

    // Final addition
    assign product = s3 + c3 + {31'b0, sign[8]};

    // Control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage <= 2'b00;
            a_reg <= 16'b0;
            b_reg <= 16'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end
        else begin
            case (stage)
                2'b00: begin  // Idle
                    done <= 1'b0;
                    if (start) begin
                        a_reg <= ain;
                        b_reg <= bin;
                        stage <= 2'b01;
                    end
                end
                2'b01: begin  // Booth encoding
                    stage <= 2'b10;
                end
                2'b10: begin  // Wallace tree reduction
                    stage <= 2'b11;
                end
                2'b11: begin  // Final addition
                    yout <= product;
                    done <= 1'b1;
                    stage <= 2'b00;
                end
            endcase
        end
    end

endmodule

// 4:2 compressor module
module compressor_4to2 (
    input [31:0] a, b, c, d,
    output [31:0] sum, carry
);
    wire [31:0] s0 = a ^ b ^ c ^ d;
    wire [31:0] c0 = (a & b) | (c & d) | ((a | b) & (c | d));
    
    assign sum = s0;
    assign carry = {c0[30:0], 1'b0};
endmodule