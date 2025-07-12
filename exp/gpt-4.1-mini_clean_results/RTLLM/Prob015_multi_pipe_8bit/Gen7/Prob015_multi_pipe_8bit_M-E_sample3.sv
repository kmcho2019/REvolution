module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1: Register inputs and enable
reg [7:0] mul_a_s1, mul_b_s1;
reg       mul_en_s1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_s1   <= 8'd0;
        mul_b_s1   <= 8'd0;
        mul_en_s1  <= 1'b0;
    end else begin
        mul_en_s1 <= mul_en_in;
        if(mul_en_in) begin
            mul_a_s1 <= mul_a;
            mul_b_s1 <= mul_b;
        end
    end
end

// Stage 2: Partial product generation & sum for lower 4 bits of mul_b (bits 0 to 3)
reg [15:0] pp_low [3:0];
reg [15:0] sum_low;
reg        mul_en_s2;

integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<4; i=i+1) pp_low[i] <= 16'd0;
        sum_low <= 16'd0;
        mul_en_s2 <= 1'b0;
    end else begin
        mul_en_s2 <= mul_en_s1;
        if(mul_en_s1) begin
            pp_low[0] <= mul_b_s1[0] ? {8'd0, mul_a_s1}          : 16'd0;
            pp_low[1] <= mul_b_s1[1] ? ({7'd0, mul_a_s1} << 1)  : 16'd0;
            pp_low[2] <= mul_b_s1[2] ? ({6'd0, mul_a_s1} << 2)  : 16'd0;
            pp_low[3] <= mul_b_s1[3] ? ({5'd0, mul_a_s1} << 3)  : 16'd0;
            sum_low <=  (mul_b_s1[0] ? (mul_a_s1 << 0) : 16'd0) +
                        (mul_b_s1[1] ? (mul_a_s1 << 1) : 16'd0) +
                        (mul_b_s1[2] ? (mul_a_s1 << 2) : 16'd0) +
                        (mul_b_s1[3] ? (mul_a_s1 << 3) : 16'd0);
        end else begin
            sum_low <= 16'd0;
            for(i=0; i<4; i=i+1) pp_low[i] <= 16'd0;
        end
    end
end

// Stage 3: Partial product generation & sum for upper 4 bits of mul_b (bits 4 to 7)
reg [15:0] pp_high [3:0];
reg [15:0] sum_high;
reg        mul_en_s3;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<4; i=i+1) pp_high[i] <= 16'd0;
        sum_high <= 16'd0;
        mul_en_s3 <= 1'b0;
    end else begin
        mul_en_s3 <= mul_en_s2;
        if(mul_en_s2) begin
            pp_high[0] <= mul_b_s1[4] ? (mul_a_s1 << 4)         : 16'd0;
            pp_high[1] <= mul_b_s1[5] ? (mul_a_s1 << 5)         : 16'd0;
            pp_high[2] <= mul_b_s1[6] ? (mul_a_s1 << 6)         : 16'd0;
            pp_high[3] <= mul_b_s1[7] ? (mul_a_s1 << 7)         : 16'd0;
            sum_high <=  (mul_b_s1[4] ? (mul_a_s1 << 4) : 16'd0) +
                         (mul_b_s1[5] ? (mul_a_s1 << 5) : 16'd0) +
                         (mul_b_s1[6] ? (mul_a_s1 << 6) : 16'd0) +
                         (mul_b_s1[7] ? (mul_a_s1 << 7) : 16'd0);
        end else begin
            sum_high <= 16'd0;
            for(i=0; i<4; i=i+1) pp_high[i] <= 16'd0;
        end
    end
end

// Stage 4: Final product calculation by adding sum_low and sum_high
reg [15:0] mul_out_reg;
reg        mul_en_s4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        mul_en_s4 <= 1'b0;
    end else begin
        mul_en_s4 <= mul_en_s3;
        if(mul_en_s3) begin
            mul_out_reg <= sum_low + sum_high;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

// Output assignments with registered output enable delayed 4 stages
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= mul_en_s4;
        mul_out <= mul_en_s4 ? mul_out_reg : 16'd0;
    end
end

endmodule