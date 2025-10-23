module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Stage 1: Input Control and Registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Stage 2: Partial Product Generation
reg [15:0] partial_product;
reg [15:0] product_reg;
reg [2:0] state;
reg [7:0] mul_b_shift;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b000;
        mul_b_shift <= 8'b0;
        partial_product <= 16'b0;
        product_reg <= 16'b0;
    end else begin
        case (state)
            3'b000: begin
                if (mul_en_in) begin
                    mul_b_shift <= mul_b;
                    partial_product <= 16'b0;
                    product_reg <= 16'b0;
                    state <= 3'b001;
                end else begin
                    state <= 3'b000;
                end
            end
            3'b001: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {8'b0, mul_a_reg};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b010;
            end
            3'b010: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {7'b0, mul_a_reg, 1'b0};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b011;
            end
            3'b011: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {6'b0, mul_a_reg, 2'b00};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b100;
            end
            3'b100: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {5'b0, mul_a_reg, 3'b000};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b101;
            end
            3'b101: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {4'b0, mul_a_reg, 4'b0000};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b110;
            end
            3'b110: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {3'b0, mul_a_reg, 5'b00000};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b111;
            end
            3'b111: begin
                if (mul_b_shift[0] == 1'b1) begin
                    partial_product <= partial_product + {2'b0, mul_a_reg, 6'b000000};
                end
                mul_b_shift <= mul_b_shift >> 1;
                product_reg <= partial_product;
                state <= 3'b000;
            end
            default: begin
                state <= 3'b000;
            end
        endcase
    end
end

// Output Assignment
assign mul_en_out = (state == 3'b111) ? 1'b1 : 1'b0;
assign mul_out = (mul_en_out) ? product_reg : 16'b0;

endmodule