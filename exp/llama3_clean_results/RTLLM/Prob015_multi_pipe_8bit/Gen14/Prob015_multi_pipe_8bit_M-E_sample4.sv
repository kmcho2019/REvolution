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
        assign partial_product[i] = (mul_b_reg[i]) ? {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

// Partial Sum Calculation
reg [15:0] partial_sum [7:0];
always @(posedge clk) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            partial_sum[i] <= 16'b0;
        end
    end else begin
        partial_sum[0] <= partial_product[0];
        for (int i = 1; i < 8; i++) begin
            partial_sum[i] <= partial_sum[i-1] + partial_product[i];
        end
    end
end

// Final Product Calculation
reg [15:0] mul_out_reg;
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= partial_sum[7];
    end
end

// Control Unit
reg [1:0] state;
always @(posedge clk) begin
    if (!rst_n) begin
        state <= 2'b00;
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
    end
end

// Output assignment
assign mul_en_out = (state == 2'b10) ? 1'b1 : 1'b0;
assign mul_out = (state == 2'b10) ? mul_out_reg : 16'b0;

endmodule