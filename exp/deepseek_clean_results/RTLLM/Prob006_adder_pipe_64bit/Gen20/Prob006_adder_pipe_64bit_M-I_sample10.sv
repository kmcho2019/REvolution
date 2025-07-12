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
reg [15:0] a_stg2, b_stg2;
reg [15:0] a_stg3, b_stg3;
reg [15:0] a_stg4, b_stg4;

reg [3:0] en_pipe;
reg carry_stg1, carry_stg2, carry_stg3;

// Intermediate sums
wire [16:0] sum_stg1, sum_stg2, sum_stg3, sum_stg4;

// Stage 1: Bits [15:0]
assign sum_stg1 = {1'b0, a_stg1} + {1'b0, b_stg1};

// Stage 2: Bits [31:16] with carry from stage 1
assign sum_stg2 = {1'b0, a_stg2} + {1'b0, b_stg2} + {16'b0, carry_stg1};

// Stage 3: Bits [47:32] with carry from stage 2
assign sum_stg3 = {1'b0, a_stg3} + {1'b0, b_stg3} + {16'b0, carry_stg2};

// Stage 4: Bits [63:48] with carry from stage 3
assign sum_stg4 = {1'b0, a_stg4} + {1'b0, b_stg4} + {16'b0, carry_stg3};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_stg1 <= 16'b0; b_stg1 <= 16'b0;
        a_stg2 <= 16'b0; b_stg2 <= 16'b0;
        a_stg3 <= 16'b0; b_stg3 <= 16'b0;
        a_stg4 <= 16'b0; b_stg4 <= 16'b0;
        carry_stg1 <= 1'b0;
        carry_stg2 <= 1'b0;
        carry_stg3 <= 1'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1: Capture LSBs
        a_stg1 <= adda[15:0];
        b_stg1 <= addb[15:0];
        carry_stg1 <= sum_stg1[16];
        
        // Pipeline stage 2
        a_stg2 <= adda[31:16];
        b_stg2 <= addb[31:16];
        carry_stg2 <= sum_stg2[16];
        
        // Pipeline stage 3
        a_stg3 <= adda[47:32];
        b_stg3 <= addb[47:32];
        carry_stg3 <= sum_stg3[16];
        
        // Pipeline stage 4
        a_stg4 <= adda[63:48];
        b_stg4 <= addb[63:48];
        
        // Enable signal pipeline
        en_pipe <= {en_pipe[2:0], i_en};
        
        // Final result assembly
        result <= {sum_stg4[15:0], sum_stg3[15:0], 
                  sum_stg2[15:0], sum_stg1[15:0]};
        
        // Output enable (matches final pipeline stage)
        o_en <= en_pipe[3];
    end
end

endmodule