module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input Buffering
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
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
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i++) begin
            partial_product[i] <= 16'b0;
        end
    end else begin
        for (i = 0; i < 8; i++) begin
            if (mul_b_reg[i]) begin
                partial_product[i] <= {8'b0, mul_a_reg} << i;
            end else begin
                partial_product[i] <= 16'b0;
            end
        end
    end
end

// Partial Sum Calculation
reg [15:0] partial_sum [7:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i++) begin
            partial_sum[i] <= 16'b0;
        end
    end else begin
        partial_sum[0] <= partial_product[0];
        for (i = 1; i < 8; i++) begin
            partial_sum[i] <= partial_sum[i-1] + partial_product[i];
        end
    end
end

// Final Product Calculation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= partial_sum[7];
    end
end

// Control Unit
reg [1:0] state;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        mul_en_out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if (mul_en_in) begin
                    state <= 2'b01; // multiply
                    mul_en_out <= 1'b0;
                end
            end
            2'b01: begin // multiply
                state <= 2'b10; // done
                mul_en_out <= 1'b1;
            end
            2'b10: begin // done
                if (!mul_en_in) begin
                    state <= 2'b00; // idle
                    mul_en_out <= 1'b0;
                end
            end
        endcase
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
    end else if (state == 2'b10) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule