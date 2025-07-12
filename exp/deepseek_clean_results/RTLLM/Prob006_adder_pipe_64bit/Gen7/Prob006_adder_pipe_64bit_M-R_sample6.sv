module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Configuration
parameter SEGMENT_WIDTH = 8;
localparam NUM_SEGMENTS = 64/SEGMENT_WIDTH;
localparam LOWER_BITS = 32;

// Pipeline state
typedef enum logic [1:0] {IDLE, STAGE1, STAGE2} pipe_state_t;
pipe_state_t state, next_state;

// Operand registers
reg [63:0] a_reg, b_reg;

// Stage 1 results (lower 32 bits)
wire [31:0] lower_sum;
wire lower_carry;

// Stage 2 results (upper 32 bits)
wire [31:0] upper_sum;
wire final_carry;

// Carry-select segments for lower 32 bits (8-bit segments)
wire [7:0] seg0_sum_c0 = a_reg[7:0] + b_reg[7:0];
wire seg0_carry_c0 = (a_reg[7:0] + b_reg[7:0]) >> 8;
wire [7:0] seg0_sum_c1 = a_reg[7:0] + b_reg[7:0] + 1'b1;
wire seg0_carry_c1 = (a_reg[7:0] + b_reg[7:0] + 1'b1) >> 8;

wire [7:0] seg1_sum_c0 = a_reg[15:8] + b_reg[15:8];
wire seg1_carry_c0 = (a_reg[15:8] + b_reg[15:8]) >> 8;
wire [7:0] seg1_sum_c1 = a_reg[15:8] + b_reg[15:8] + 1'b1;
wire seg1_carry_c1 = (a_reg[15:8] + b_reg[15:8] + 1'b1) >> 8;

wire [7:0] seg2_sum_c0 = a_reg[23:16] + b_reg[23:16];
wire seg2_carry_c0 = (a_reg[23:16] + b_reg[23:16]) >> 8;
wire [7:0] seg2_sum_c1 = a_reg[23:16] + b_reg[23:16] + 1'b1;
wire seg2_carry_c1 = (a_reg[23:16] + b_reg[23:16] + 1'b1) >> 8;

wire [7:0] seg3_sum_c0 = a_reg[31:24] + b_reg[31:24];
wire seg3_carry_c0 = (a_reg[31:24] + b_reg[31:24]) >> 8;
wire [7:0] seg3_sum_c1 = a_reg[31:24] + b_reg[31:24] + 1'b1;
wire seg3_carry_c1 = (a_reg[31:24] + b_reg[31:24] + 1'b1) >> 8;

// Mux lower segment results based on carry chain
wire [7:0] seg0_sum = seg0_sum_c0;
wire seg0_carry = seg0_carry_c0;

wire [7:0] seg1_sum = seg0_carry ? seg1_sum_c1 : seg1_sum_c0;
wire seg1_carry = seg0_carry ? seg1_carry_c1 : seg1_carry_c0;

wire [7:0] seg2_sum = seg1_carry ? seg2_sum_c1 : seg2_sum_c0;
wire seg2_carry = seg1_carry ? seg2_carry_c1 : seg2_carry_c0;

wire [7:0] seg3_sum = seg2_carry ? seg3_sum_c1 : seg3_sum_c0;
wire seg3_carry = seg2_carry ? seg3_carry_c1 : seg3_carry_c0;

assign lower_sum = {seg3_sum, seg2_sum, seg1_sum, seg0_sum};
assign lower_carry = seg3_carry;

// Ripple-carry for upper 32 bits
wire [32:0] upper_result = {1'b0, a_reg[63:32]} + {1'b0, b_reg[63:32]} + lower_carry;
assign upper_sum = upper_result[31:0];
assign final_carry = upper_result[32];

// State machine and pipeline control
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (i_en) next_state = STAGE1;
        STAGE1: next_state = STAGE2;
        STAGE2: next_state = IDLE;
    endcase
end

// Pipeline registers and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        state <= next_state;
        
        case (state)
            IDLE: begin
                if (i_en) begin
                    a_reg <= adda;
                    b_reg <= addb;
                end
                o_en <= 1'b0;
            end
            
            STAGE1: begin
                // Stage 1 results are ready via continuous assignments
                o_en <= 1'b0;
            end
            
            STAGE2: begin
                result <= {final_carry, upper_sum, lower_sum};
                o_en <= 1'b1;
            end
        endcase
    end
end

endmodule