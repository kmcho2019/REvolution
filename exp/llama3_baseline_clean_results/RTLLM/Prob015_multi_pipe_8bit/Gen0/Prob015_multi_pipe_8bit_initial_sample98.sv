module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    reg [7:0] mul_en_out_reg;
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    wire [15:0] temp;
    reg [15:0] sum [7:0];
    reg [15:0] mul_out_reg;

    // Input control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out_reg <= 0;
        end else if (mul_en_in) begin
            mul_en_out_reg <= {mul_en_in, 7'd0};
        end
    end

    // Input registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial product generation
    assign temp = (mul_b_reg[0] ? {8'd0, mul_a_reg} : 16'd0) +
                  (mul_b_reg[1] ? {7'd0, mul_a_reg, 1'd0} : 16'd0) +
                  (mul_b_reg[2] ? {6'd0, mul_a_reg, 2'd0} : 16'd0) +
                  (mul_b_reg[3] ? {5'd0, mul_a_reg, 3'd0} : 16'd0) +
                  (mul_b_reg[4] ? {4'd0, mul_a_reg, 4'd0} : 16'd0) +
                  (mul_b_reg[5] ? {3'd0, mul_a_reg, 5'd0} : 16'd0) +
                  (mul_b_reg[6] ? {2'd0, mul_a_reg, 6'd0} : 16'd0) +
                  (mul_b_reg[7] ? {1'd0, mul_a_reg, 7'd0} : 16'd0);

    // Partial sum calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum[0] <= 0;
            sum[1] <= 0;
            sum[2] <= 0;
            sum[3] <= 0;
            sum[4] <= 0;
            sum[5] <= 0;
            sum[6] <= 0;
            sum[7] <= 0;
        end else begin
            sum[0] <= (mul_b_reg[0] ? {8'd0, mul_a_reg} : 16'd0);
            sum[1] <= (mul_b_reg[1] ? {7'd0, mul_a_reg, 1'd0} : 16'd0) + sum[0];
            sum[2] <= (mul_b_reg[2] ? {6'd0, mul_a_reg, 2'd0} : 16'd0) + sum[1];
            sum[3] <= (mul_b_reg[3] ? {5'd0, mul_a_reg, 3'd0} : 16'd0) + sum[2];
            sum[4] <= (mul_b_reg[4] ? {4'd0, mul_a_reg, 4'd0} : 16'd0) + sum[3];
            sum[5] <= (mul_b_reg[5] ? {3'd0, mul_a_reg, 5'd0} : 16'd0) + sum[4];
            sum[6] <= (mul_b_reg[6] ? {2'd0, mul_a_reg, 6'd0} : 16'd0) + sum[5];
            sum[7] <= (mul_b_reg[7] ? {1'd0, mul_a_reg, 7'd0} : 16'd0) + sum[6];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 0;
        end else begin
            mul_out_reg <= sum[7];
        end
    end

    // Output assignment
    always @(*) begin
        if (mul_en_out_reg[7]) begin
            mul_out = mul_out_reg;
        end else begin
            mul_out = 0;
        end
    end

    assign mul_en_out = mul_en_out_reg[7];

endmodule