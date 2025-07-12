module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

// Pipeline depth = 8 (one stage per multiplier bit)

// Stage registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

// Pipeline registers: sum, bit index, enable
reg [15:0] sum_pipe [0:7];
reg [3:0]  bit_idx_pipe [0:7];
reg        en_pipe [0:7];

integer i;

// Input capture stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg   <= 8'd0;
        mul_b_reg   <= 8'd0;
        mul_en_reg  <= 1'b0;
    end else begin
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Pipeline stage 0 (first stage)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_pipe[0]    <= 16'd0;
        bit_idx_pipe[0]<= 4'd0;
        en_pipe[0]     <= 1'b0;
    end else begin
        en_pipe[0]     <= mul_en_reg;
        bit_idx_pipe[0]<= 4'd0;
        if (mul_en_reg) begin
            sum_pipe[0] <= (mul_b_reg[0]) ? {8'd0, mul_a_reg} : 16'd0;
        end else begin
            sum_pipe[0] <= 16'd0;
        end
    end
end

// Pipeline stages 1 to 7
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i=1; i<8; i=i+1) begin
            sum_pipe[i]     <= 16'd0;
            bit_idx_pipe[i] <= 4'd0;
            en_pipe[i]      <= 1'b0;
        end
    end else begin
        for (i=1; i<8; i=i+1) begin
            en_pipe[i]      <= en_pipe[i-1];
            bit_idx_pipe[i] <= bit_idx_pipe[i-1] + 1;
            if (en_pipe[i-1]) begin
                // Add shifted mul_a if corresponding multiplier bit is 1
                sum_pipe[i] <= sum_pipe[i-1] + (mul_b_reg[bit_idx_pipe[i-1]+1] ? (mul_a_reg << (bit_idx_pipe[i-1]+1)) : 16'd0);
            end else begin
                sum_pipe[i] <= 16'd0;
            end
        end
    end
end

// Output assignment from last stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= en_pipe[7];
        mul_out    <= en_pipe[7] ? sum_pipe[7] : 16'd0;
    end
end

endmodule