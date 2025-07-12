module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [15:0] a0, a1, a2, a3;
reg [15:0] b0, b1, b2, b3;
reg carry0, carry1, carry2;
reg [3:0] en_pipe;

// Intermediate sums
wire [16:0] sum0, sum1, sum2, sum3;

// Stage 0: bits [15:0]
assign sum0 = {1'b0, a0} + {1'b0, b0};

// Stage 1: bits [31:16] with carry
assign sum1 = {1'b0, a1} + {1'b0, b1} + {16'b0, carry0};

// Stage 2: bits [47:32] with carry
assign sum2 = {1'b0, a2} + {1'b0, b2} + {16'b0, carry1};

// Stage 3: bits [63:48] with carry
assign sum3 = {1'b0, a3} + {1'b0, b3} + {16'b0, carry2};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a0 <= 16'b0; a1 <= 16'b0; a2 <= 16'b0; a3 <= 16'b0;
        b0 <= 16'b0; b1 <= 16'b0; b2 <= 16'b0; b3 <= 16'b0;
        carry0 <= 1'b0; carry1 <= 1'b0; carry2 <= 1'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Register first 16 bits
        a0 <= adda[15:0];
        b0 <= addb[15:0];
        carry0 <= sum0[16];
        
        // Pipeline stage 1: Register next 16 bits
        a1 <= adda[31:16];
        b1 <= addb[31:16];
        carry1 <= sum1[16];
        
        // Pipeline stage 2: Register next 16 bits
        a2 <= adda[47:32];
        b2 <= addb[47:32];
        carry2 <= sum2[16];
        
        // Pipeline stage 3: Register final 16 bits
        a3 <= adda[63:48];
        b3 <= addb[63:48];
        
        // Compose final result
        result <= {sum3[15:0], sum2[15:0], sum1[15:0], sum0[15:0]};
        result[64] <= sum3[16];
        
        // Pipeline enable signal
        en_pipe <= {en_pipe[2:0], i_en};
        o_en <= en_pipe[3];
    end
end

endmodule