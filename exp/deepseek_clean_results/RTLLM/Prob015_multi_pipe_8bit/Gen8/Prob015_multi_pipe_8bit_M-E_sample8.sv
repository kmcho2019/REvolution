module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline registers
reg [7:0] a_reg, b_reg;
reg [2:0] en_pipe;
wire [8:0] booth_encoded [3:0];
wire [15:0] pp [3:0];
wire [15:0] sum1, sum2, carry1, carry2;
reg [15:0] sum_reg, carry_reg;

// Booth encoder (radix-4)
assign booth_encoded[0] = {b_reg[1:0], 1'b0};
assign booth_encoded[1] = b_reg[3:1];
assign booth_encoded[2] = b_reg[5:3];
assign booth_encoded[3] = b_reg[7:5];

// Partial product generator
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : pp_gen
        always @(*) begin
            case (booth_encoded[i])
                3'b000: pp[i] = 16'b0;
                3'b001: pp[i] = {8'b0, a_reg};
                3'b010: pp[i] = {8'b0, a_reg};
                3'b011: pp[i] = {7'b0, a_reg, 1'b0};
                3'b100: pp[i] = ~{7'b0, a_reg, 1'b0} + 1'b1;
                3'b101: pp[i] = ~{8'b0, a_reg} + 1'b1;
                3'b110: pp[i] = ~{8'b0, a_reg} + 1'b1;
                3'b111: pp[i] = 16'b0;
            endcase
        end
        assign pp[i] = pp[i] << (2*i); // Shift according to position
    end
endgenerate

// 4:2 compressor stage
assign {sum1, carry1} = pp[0] + pp[1] + pp[2];
assign {sum2, carry2} = sum1 + carry1 + pp[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        en_pipe <= 3'b0;
        sum_reg <= 16'b0;
        carry_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Input sampling and Booth encoding
        en_pipe <= {en_pipe[1:0], mul_en_in};
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Pipeline stage 2: Partial product compression
        sum_reg <= sum2;
        carry_reg <= carry2;

        // Pipeline stage 3: Final addition and output
        mul_out <= sum_reg + carry_reg;
        mul_en_out <= en_pipe[2];
    end
end

endmodule