module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input Buffering
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
wire [15:0] partial_product [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign partial_product[i] = (mul_b_reg[i])? {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

// Carry-Save Addition
reg [15:0] sum_reg [7:0];
reg [15:0] carry_reg [7:0];
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum_reg[i] <= 16'b0;
            carry_reg[i] <= 16'b0;
        end
    end else begin
        sum_reg[0] <= partial_product[0];
        carry_reg[0] <= 16'b0;
        for (int i = 1; i < 8; i++) begin
            sum_reg[i] <= sum_reg[i-1] + partial_product[i];
            carry_reg[i] <= carry_reg[i-1] + (sum_reg[i-1] >> 15);
        end
    end
end

// Ripple-Carry Addition
reg [15:0] mul_out_reg;
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum_reg[7] + carry_reg[7];
    end
end

// Output Buffering
reg [1:0] state;
reg mul_en_out_reg;
always @(posedge clk) begin
    if (!rst_n) begin
        state <= 2'b00;
        mul_en_out_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (mul_en_in) begin
                    state <= 2'b01; // multiply
                end
            end
            2'b01: begin // multiply
                state <= 2'b10; // done
            end
            2'b10: begin // done
                if (!mul_en_in) begin
                    state <= 2'b00; // idle
                end
            end
        endcase
        if (state == 2'b10) begin
            mul_en_out_reg <= 1'b1;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
    end
end

// Output Assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg)? mul_out_reg : 16'b0;

endmodule