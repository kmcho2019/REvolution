module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH/STG_WIDTH;

// Pipeline registers for each stage
reg [STG_WIDTH-1:0] a0, a1, a2, a3;
reg [STG_WIDTH-1:0] b0, b1, b2, b3;
reg carry0, carry1, carry2;
reg [3:0] en_pipe;

// Intermediate sums
wire [STG_WIDTH:0] sum0, sum1, sum2, sum3;

// Stage 0: Add first 16 bits
assign sum0 = {1'b0, a0} + {1'b0, b0};

// Stage 1: Add next 16 bits with carry
assign sum1 = {1'b0, a1} + {1'b0, b1} + {16'd0, carry0};

// Stage 2: Add next 16 bits with carry
assign sum2 = {1'b0, a2} + {1'b0, b2} + {16'd0, carry1};

// Stage 3: Add final 16 bits with carry
assign sum3 = {1'b0, a3} + {1'b0, b3} + {16'd0, carry2};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a0 <= 0; a1 <= 0; a2 <= 0; a3 <= 0;
        b0 <= 0; b1 <= 0; b2 <= 0; b3 <= 0;
        carry0 <= 0; carry1 <= 0; carry2 <= 0;
        en_pipe <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0 registers
        a0 <= adda[15:0];
        b0 <= addb[15:0];
        carry0 <= sum0[16];
        
        // Stage 1 registers
        a1 <= adda[31:16];
        b1 <= addb[31:16];
        carry1 <= sum1[16];
        
        // Stage 2 registers
        a2 <= adda[47:32];
        b2 <= addb[47:32];
        carry2 <= sum2[16];
        
        // Stage 3 registers
        a3 <= adda[63:48];
        b3 <= addb[63:48];
        
        // Compose final result
        result <= {sum3[16], sum3[15:0], sum2[15:0], sum1[15:0], sum0[15:0]};
        
        // Pipeline enable signal
        en_pipe <= {en_pipe[2:0], i_en};
        o_en <= en_pipe[3];
    end
end

endmodule