module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Stage 1: Input registration and Booth encoding
    reg [7:0] a_reg, b_reg;
    reg en_reg1;
    wire [2:0] booth_sel [3:0];
    
    // Booth encoder
    assign booth_sel[0] = {b_reg[1], b_reg[0], 1'b0};
    assign booth_sel[1] = b_reg[3:1];
    assign booth_sel[2] = b_reg[5:3];
    assign booth_sel[3] = {b_reg[7], b_reg[7:6]};

    // Stage 2: Partial product generation and compression
    reg [15:0] pp [3:0];
    reg en_reg2;
    wire [15:0] sum, carry;
    
    // Booth decoder and partial product generation
    always @(*) begin
        for (integer i = 0; i < 4; i = i + 1) begin
            case (booth_sel[i])
                3'b000, 3'b111: pp[i] = 16'b0;
                3'b001, 3'b010: pp[i] = {8'b0, a_reg} << (2*i);
                3'b011:         pp[i] = {7'b0, a_reg, 1'b0} << (2*i);
                3'b100:         pp[i] = ~({7'b0, a_reg, 1'b0} << (2*i)) + 1;
                3'b101, 3'b110: pp[i] = ~({8'b0, a_reg} << (2*i)) + 1;
            endcase
        end
    end

    // 4:2 compressor for partial products
    wire [15:0] c1, s1, c2, s2;
    assign {c1, s1} = pp[0] + pp[1];
    assign {c2, s2} = pp[2] + pp[3];
    assign sum = s1 + s2;
    assign carry = c1 + c2;

    // Stage 3: Final addition and output
    reg [15:0] final_sum;
    reg en_reg3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            final_sum <= 16'b0;
            en_reg3 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            en_reg1 <= mul_en_in;

            // Stage 2: Partial product compression
            en_reg2 <= en_reg1;

            // Stage 3: Final addition
            final_sum <= sum + carry + (carry << 1);
            en_reg3 <= en_reg2;

            // Output
            mul_en_out <= en_reg3;
            mul_out <= en_reg3 ? final_sum : 16'b0;
        end
    end

endmodule