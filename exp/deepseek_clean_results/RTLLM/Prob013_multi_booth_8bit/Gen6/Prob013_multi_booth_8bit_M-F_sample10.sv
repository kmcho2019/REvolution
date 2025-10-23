module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Pipeline registers
    reg [15:0] stage1_pp [0:3];
    reg [15:0] stage2_sum, stage2_carry;
    reg [15:0] stage3_result;
    reg stage1_valid, stage2_valid, stage3_valid;

    // Sign-extended operands
    wire [15:0] a_ext = {{8{a[7]}}, a};
    wire [15:0] b_ext = {{8{b[7]}}, b};

    // Booth encoding bits (current + previous)
    reg [2:0] booth_bits [0:3];
    reg [1:0] sel [0:3]; // Changed to reg

    // Generate all possible multiples
    wire [15:0] x0 = 16'b0;
    wire [15:0] x1 = a_ext;
    wire [15:0] x2 = {a_ext[14:0], 1'b0};
    wire [15:0] x_neg1 = -a_ext;
    wire [15:0] x_neg2 = -x2;

    // Generate booth encodings for all 4 steps
    always @(posedge clk) begin
        if (reset) begin
            for (integer i = 0; i < 4; i = i+1) begin
                booth_bits[i] <= 3'b0;
            end
        end else begin
            booth_bits[0] <= {b_ext[1:0], 1'b0};
            booth_bits[1] <= b_ext[3:1];
            booth_bits[2] <= b_ext[5:3];
            booth_bits[3] <= b_ext[7:5];
        end
    end

    // Booth decoder for each partial product
    always @(*) begin
        for (integer i = 0; i < 4; i = i+1) begin
            case (booth_bits[i])
                3'b000, 3'b111: sel[i] = 2'b00; // 0
                3'b001, 3'b010: sel[i] = 2'b01; // +1
                3'b011:         sel[i] = 2'b10; // +2
                3'b100:         sel[i] = 2'b11; // -2
                3'b101, 3'b110: sel[i] = 2'b01; // -1 (special handling)
                default:       sel[i] = 2'b00;
            endcase
        end
    end

    // Partial product selection with proper shifting
    always @(posedge clk) begin
        if (reset) begin
            for (integer i = 0; i < 4; i = i+1) begin
                stage1_pp[i] <= 16'b0;
            end
        end else begin
            for (integer i = 0; i < 4; i = i+1) begin
                case (sel[i])
                    2'b00: stage1_pp[i] <= x0;
                    2'b01: stage1_pp[i] <= (booth_bits[i][2]) ? x_neg1 : x1;
                    2'b10: stage1_pp[i] <= x2;
                    2'b11: stage1_pp[i] <= x_neg2;
                endcase
            end
        end
    end

    // Pipeline stage 1: Partial product generation
    always @(posedge clk) begin
        if (reset) begin
            stage1_valid <= 1'b0;
        end else begin
            stage1_valid <= ~reset;
        end
    end

    // Pipeline stage 2: Wallace tree compression
    wire [15:0] s1, c1;
    compressor_4to2 comp1 (
        .a(stage1_pp[0]),
        .b(stage1_pp[1] << 2),
        .c(stage1_pp[2] << 4),
        .d(stage1_pp[3] << 6),
        .sum(s1),
        .carry(c1)
    );

    // Register compression results
    always @(posedge clk) begin
        if (reset) begin
            stage2_sum <= 16'b0;
            stage2_carry <= 16'b0;
            stage2_valid <= 1'b0;
        end else begin
            stage2_sum <= s1;
            stage2_carry <= c1 << 1;
            stage2_valid <= stage1_valid;
        end
    end

    // Pipeline stage 3: Final addition
    always @(posedge clk) begin
        if (reset) begin
            stage3_result <= 16'b0;
            stage3_valid <= 1'b0;
        end else begin
            stage3_result <= stage2_sum + stage2_carry;
            stage3_valid <= stage2_valid;
        end
    end

    // Output assignment
    always @(posedge clk) begin
        if (reset) begin
            p <= 16'b0;
            rdy <= 1'b0;
        end else begin
            p <= stage3_result;
            rdy <= stage3_valid;
        end
    end

endmodule

// 4:2 compressor module for Wallace tree
module compressor_4to2 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    output [15:0] sum,
    output [15:0] carry
);
    wire [15:0] s1 = a ^ b ^ c ^ d;
    wire [15:0] c1 = (a & b) | (c & d) | ((a | b) & (c | d));
    
    assign sum = s1;
    assign carry = c1;
endmodule