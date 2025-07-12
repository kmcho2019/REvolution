module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [15:0] a_stg1, b_stg1;
reg [31:16] a_stg2, b_stg2;
reg [47:32] a_stg3, b_stg3;
reg [63:48] a_stg4, b_stg4;
reg [3:0] en_pipeline;

// Intermediate results
wire [16:0] sum_stg1;
wire [32:16] sum_stg2_0, sum_stg2_1;
wire [48:32] sum_stg3_0, sum_stg3_1;
wire [64:48] sum_stg4;

// Carry signals
wire carry_stg1;
reg carry_stg2, carry_stg3;

// Stage 1: Initial 16-bit ripple carry addition
assign {carry_stg1, sum_stg1[15:0]} = a_stg1 + b_stg1;
assign sum_stg1[16] = carry_stg1;

// Stage 2: Carry-select for bits 16-31
assign sum_stg2_0 = a_stg2 + b_stg2;
assign sum_stg2_1 = a_stg2 + b_stg2 + 1'b1;

// Stage 3: Carry-select for bits 32-47
assign sum_stg3_0 = a_stg3 + b_stg3;
assign sum_stg3_1 = a_stg3 + b_stg3 + 1'b1;

// Stage 4: Final addition for bits 48-63
assign sum_stg4 = {1'b0, a_stg4} + {1'b0, b_stg4} + carry_stg3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_stg1 <= 16'b0; b_stg1 <= 16'b0;
        a_stg2 <= 16'b0; b_stg2 <= 16'b0;
        a_stg3 <= 16'b0; b_stg3 <= 16'b0;
        a_stg4 <= 16'b0; b_stg4 <= 16'b0;
        en_pipeline <= 4'b0;
        carry_stg2 <= 1'b0;
        carry_stg3 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1: Input registration
        if (i_en) begin
            a_stg1 <= adda[15:0];
            b_stg1 <= addb[15:0];
            a_stg2 <= adda[31:16];
            b_stg2 <= addb[31:16];
            a_stg3 <= adda[47:32];
            b_stg3 <= addb[47:32];
            a_stg4 <= adda[63:48];
            b_stg4 <= addb[63:48];
        end
        
        // Pipeline enable signals
        en_pipeline <= {en_pipeline[2:0], i_en};
        
        // Pipeline stage 2: Carry selection
        carry_stg2 <= sum_stg1[16] ? sum_stg2_1[16] : sum_stg2_0[16];
        
        // Pipeline stage 3: Carry propagation
        carry_stg3 <= carry_stg2;
        
        // Pipeline stage 4: Result assembly
        result <= {sum_stg4, 
                  carry_stg2 ? sum_stg3_1 : sum_stg3_0,
                  sum_stg1[15:0]};
        
        // Output enable generation
        o_en <= en_pipeline[3];
    end
end

endmodule