module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Configuration parameters
parameter SEGMENT_WIDTH = 8;
parameter CARRY_SELECT_BITS = 32;
localparam NUM_SEGMENTS = 64/SEGMENT_WIDTH;
localparam CS_SEGMENTS = CARRY_SELECT_BITS/SEGMENT_WIDTH;

// Pipeline registers
reg [63:0] a_reg, b_reg;
reg [31:0] lower_sum;
reg lower_carry;
reg stage1_valid;

// Carry-select implementation for first 32 bits
wire [31:0] sum0_c0, sum0_c1;
wire carry0_c0, carry0_c1;

// Generate carry-select segments
genvar i;
generate
    for (i = 0; i < CS_SEGMENTS; i = i + 1) begin : cs_adder
        // Compute segment with carry=0 and carry=1
        wire [SEGMENT_WIDTH:0] seg_sum_c0 = {1'b0, a_reg[i*SEGMENT_WIDTH +: SEGMENT_WIDTH]} + 
                                           {1'b0, b_reg[i*SEGMENT_WIDTH +: SEGMENT_WIDTH]} + 
                                           1'b0;
        
        wire [SEGMENT_WIDTH:0] seg_sum_c1 = {1'b0, a_reg[i*SEGMENT_WIDTH +: SEGMENT_WIDTH]} + 
                                           {1'b0, b_reg[i*SEGMENT_WIDTH +: SEGMENT_WIDTH]} + 
                                           1'b1;
        
        // Mux results based on actual carry
        if (i == 0) begin
            // First segment uses actual carry-in (0)
            assign sum0_c0[i*SEGMENT_WIDTH +: SEGMENT_WIDTH] = seg_sum_c0[SEGMENT_WIDTH-1:0];
            assign carry0_c0 = seg_sum_c0[SEGMENT_WIDTH];
        end else begin
            // Subsequent segments use muxed results
            assign sum0_c0[i*SEGMENT_WIDTH +: SEGMENT_WIDTH] = lower_carry ? 
                seg_sum_c1[SEGMENT_WIDTH-1:0] : seg_sum_c0[SEGMENT_WIDTH-1:0];
            assign carry0_c0 = lower_carry ? 
                seg_sum_c1[SEGMENT_WIDTH] : seg_sum_c0[SEGMENT_WIDTH];
        end
    end
endgenerate

// Ripple-carry implementation for upper 32 bits
wire [31:0] upper_sum;
wire final_carry;
wire [32:0] ripple_sum = {1'b0, a_reg[63:32]} + {1'b0, b_reg[63:32]} + carry0_c0;

assign upper_sum = ripple_sum[31:0];
assign final_carry = ripple_sum[32];

// Pipeline stage 1: Compute lower 32 bits
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        lower_sum <= 32'b0;
        lower_carry <= 1'b0;
        stage1_valid <= 1'b0;
    end else if (i_en) begin
        a_reg <= adda;
        b_reg <= addb;
        lower_sum <= sum0_c0;
        lower_carry <= carry0_c0;
        stage1_valid <= 1'b1;
    end else begin
        stage1_valid <= 1'b0;
    end
end

// Pipeline stage 2: Compute upper 32 bits and final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (stage1_valid) begin
            result <= {final_carry, upper_sum, lower_sum};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule