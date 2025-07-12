module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers (dual-edge triggered)
reg [23:0] sum0_neg, sum0_pos;
reg [23:0] sum1_neg, sum1_pos;
reg [15:0] sum2_neg, sum2_pos;
reg carry0_neg, carry0_pos;
reg carry1_neg, carry1_pos;
reg [2:0] en_pipe_neg, en_pipe_pos;

// Internal signals
wire [24:0] seg0_sum;
wire [24:0] seg1_sum0, seg1_sum1;
wire [16:0] seg2_sum;
wire carry_pred;

// Carry prediction (using lower bits)
assign carry_pred = (adda[7:0] + addb[7:0] > 255) ? 1'b1 : 1'b0;

// Stage 0: 24-bit ripple-carry (bits 0-23)
assign seg0_sum = {1'b0, adda[23:0]} + {1'b0, addb[23:0]};

// Stage 1: 24-bit carry-select (bits 24-47)
assign seg1_sum0 = {1'b0, adda[47:24]} + {1'b0, addb[47:24]};
assign seg1_sum1 = seg1_sum0 + 1'b1;

// Stage 2: 16-bit ripple-carry with early carry (bits 48-63)
assign seg2_sum = {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + 
                 (carry_pred ? carry1_pos : carry1_neg);

always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_neg <= 24'b0;
        sum1_neg <= 24'b0;
        sum2_neg <= 16'b0;
        carry0_neg <= 1'b0;
        carry1_neg <= 1'b0;
        en_pipe_neg <= 3'b0;
    end else begin
        // Negative edge pipeline
        sum0_neg <= seg0_sum[23:0];
        carry0_neg <= seg0_sum[24];
        
        // Carry-select mux using predicted carry
        if (carry_pred) begin
            sum1_neg <= seg1_sum1[23:0];
            carry1_neg <= seg1_sum1[24];
        end else begin
            sum1_neg <= seg1_sum0[23:0];
            carry1_neg <= seg1_sum0[24];
        end
        
        en_pipe_neg <= {en_pipe_neg[1:0], i_en};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_pos <= 24'b0;
        sum1_pos <= 24'b0;
        sum2_pos <= 16'b0;
        carry0_pos <= 1'b0;
        carry1_pos <= 1'b0;
        en_pipe_pos <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Positive edge pipeline
        sum0_pos <= sum0_neg;
        sum1_pos <= sum1_neg;
        sum2_pos <= seg2_sum[15:0];
        carry0_pos <= carry0_neg;
        carry1_pos <= carry1_neg;
        en_pipe_pos <= en_pipe_neg;
        
        // Final output assembly
        result <= {seg2_sum[16], sum2_pos, sum1_pos, sum0_pos};
        o_en <= en_pipe_pos[2];
    end
end

endmodule