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
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 8;

localparam NUM_SEGMENTS = DATA_WIDTH/STG_WIDTH;
localparam LOWER_BITS = DATA_WIDTH/2;

// Pipeline state
typedef enum logic [1:0] {IDLE, STAGE1, STAGE2} pipe_state_t;
pipe_state_t state, next_state;

// Operand registers
reg [DATA_WIDTH-1:0] a_reg, b_reg;

// Stage 1 results (lower half bits)
wire [LOWER_BITS-1:0] lower_sum;
wire lower_carry;

// Stage 2 results (upper half bits)
wire [LOWER_BITS-1:0] upper_sum;
wire final_carry;

// Carry-select segments for lower bits
wire [STG_WIDTH-1:0] seg0_sum_c0 = a_reg[STG_WIDTH-1:0] + b_reg[STG_WIDTH-1:0];
wire seg0_carry_c0 = (a_reg[STG_WIDTH-1:0] + b_reg[STG_WIDTH-1:0]) >> STG_WIDTH;
wire [STG_WIDTH-1:0] seg0_sum_c1 = a_reg[STG_WIDTH-1:0] + b_reg[STG_WIDTH-1:0] + 1'b1;
wire seg0_carry_c1 = (a_reg[STG_WIDTH-1:0] + b_reg[STG_WIDTH-1:0] + 1'b1) >> STG_WIDTH;

wire [STG_WIDTH-1:0] seg1_sum_c0 = a_reg[2*STG_WIDTH-1:STG_WIDTH] + b_reg[2*STG_WIDTH-1:STG_WIDTH];
wire seg1_carry_c0 = (a_reg[2*STG_WIDTH-1:STG_WIDTH] + b_reg[2*STG_WIDTH-1:STG_WIDTH]) >> STG_WIDTH;
wire [STG_WIDTH-1:0] seg1_sum_c1 = a_reg[2*STG_WIDTH-1:STG_WIDTH] + b_reg[2*STG_WIDTH-1:STG_WIDTH] + 1'b1;
wire seg1_carry_c1 = (a_reg[2*STG_WIDTH-1:STG_WIDTH] + b_reg[2*STG_WIDTH-1:STG_WIDTH] + 1'b1) >> STG_WIDTH;

wire [STG_WIDTH-1:0] seg2_sum_c0 = a_reg[3*STG_WIDTH-1:2*STG_WIDTH] + b_reg[3*STG_WIDTH-1:2*STG_WIDTH];
wire seg2_carry_c0 = (a_reg[3*STG_WIDTH-1:2*STG_WIDTH] + b_reg[3*STG_WIDTH-1:2*STG_WIDTH]) >> STG_WIDTH;
wire [STG_WIDTH-1:0] seg2_sum_c1 = a_reg[3*STG_WIDTH-1:2*STG_WIDTH] + b_reg[3*STG_WIDTH-1:2*STG_WIDTH] + 1'b1;
wire seg2_carry_c1 = (a_reg[3*STG_WIDTH-1:2*STG_WIDTH] + b_reg[3*STG_WIDTH-1:2*STG_WIDTH] + 1'b1) >> STG_WIDTH;

wire [STG_WIDTH-1:0] seg3_sum_c0 = a_reg[4*STG_WIDTH-1:3*STG_WIDTH] + b_reg[4*STG_WIDTH-1:3*STG_WIDTH];
wire seg3_carry_c0 = (a_reg[4*STG_WIDTH-1:3*STG_WIDTH] + b_reg[4*STG_WIDTH-1:3*STG_WIDTH]) >> STG_WIDTH;
wire [STG_WIDTH-1:0] seg3_sum_c1 = a_reg[4*STG_WIDTH-1:3*STG_WIDTH] + b_reg[4*STG_WIDTH-1:3*STG_WIDTH] + 1'b1;
wire seg3_carry_c1 = (a_reg[4*STG_WIDTH-1:3*STG_WIDTH] + b_reg[4*STG_WIDTH-1:3*STG_WIDTH] + 1'b1) >> STG_WIDTH;

// Mux lower segment results based on carry chain
wire [STG_WIDTH-1:0] seg0_sum = seg0_sum_c0;
wire seg0_carry = seg0_carry_c0;

wire [STG_WIDTH-1:0] seg1_sum = seg0_carry ? seg1_sum_c1 : seg1_sum_c0;
wire seg1_carry = seg0_carry ? seg1_carry_c1 : seg1_carry_c0;

wire [STG_WIDTH-1:0] seg2_sum = seg1_carry ? seg2_sum_c1 : seg2_sum_c0;
wire seg2_carry = seg1_carry ? seg2_carry_c1 : seg2_carry_c0;

wire [STG_WIDTH-1:0] seg3_sum = seg2_carry ? seg3_sum_c1 : seg3_sum_c0;
wire seg3_carry = seg2_carry ? seg3_carry_c1 : seg3_carry_c0;

assign lower_sum = {seg3_sum, seg2_sum, seg1_sum, seg0_sum};
assign lower_carry = seg3_carry;

// Ripple-carry for upper bits
wire [LOWER_BITS:0] upper_result = {1'b0, a_reg[DATA_WIDTH-1:LOWER_BITS]} + {1'b0, b_reg[DATA_WIDTH-1:LOWER_BITS]} + lower_carry;
assign upper_sum = upper_result[LOWER_BITS-1:0];
assign final_carry = upper_result[LOWER_BITS];

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
        a_reg <= {DATA_WIDTH{1'b0}};
        b_reg <= {DATA_WIDTH{1'b0}};
        result <= {DATA_WIDTH+1{1'b0}};
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