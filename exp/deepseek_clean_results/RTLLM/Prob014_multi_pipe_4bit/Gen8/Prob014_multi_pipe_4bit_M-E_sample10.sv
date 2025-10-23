module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input en,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage registers
reg [2*size-1:0] pp0, pp1;
reg [2*size-1:0] sum_reg;
reg stage1_valid, stage2_valid;

// Booth encoding and partial product generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 0;
        pp1 <= 0;
        stage1_valid <= 0;
    end else if (en) begin
        // Booth encoding (radix-4)
        case ({mul_b[1:0], 1'b0})
            3'b000, 3'b111: pp0 <= 0;
            3'b001, 3'b010: pp0 <= {{size{mul_a[size-1]}}, mul_a};
            3'b011:         pp0 <= {{size{mul_a[size-1]}}, mul_a} << 1;
            3'b100:         pp0 <= - ({{size{mul_a[size-1]}}, mul_a} << 1);
            3'b101, 3'b110: pp0 <= - {{size{mul_a[size-1]}}, mul_a};
        endcase

        case ({mul_b[3:1]})
            3'b000, 3'b111: pp1 <= 0;
            3'b001, 3'b010: pp1 <= {{size{mul_a[size-1]}}, mul_a} << 2;
            3'b011:         pp1 <= {{size{mul_a[size-1]}}, mul_a} << 3;
            3'b100:         pp1 <= - ({{size{mul_a[size-1]}}, mul_a} << 3);
            3'b101, 3'b110: pp1 <= - ({{size{mul_a[size-1]}}, mul_a} << 2);
        endcase

        stage1_valid <= 1;
    end else begin
        stage1_valid <= 0;
    end
end

// Partial product accumulation stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= 0;
        stage2_valid <= 0;
        mul_out <= 0;
    end else if (en) begin
        if (stage1_valid) begin
            sum_reg <= pp0 + pp1;
            stage2_valid <= 1;
        end else begin
            stage2_valid <= 0;
        end

        if (stage2_valid) begin
            mul_out <= sum_reg;
        end
    end
end

endmodule