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
reg [31:0] a0, a1;
reg [31:0] b0, b1;
reg carry0;
reg [1:0] en_pipe;

// Intermediate sums
wire [32:0] sum0, sum1;

// Stage 0: bits [31:0]
assign sum0 = {1'b0, a0} + {1'b0, b0};

// Stage 1: bits [63:32] with carry
assign sum1 = {1'b0, a1} + {1'b0, b1} + {32'b0, carry0};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a0 <= 32'b0; a1 <= 32'b0;
        b0 <= 32'b0; b1 <= 32'b0;
        carry0 <= 1'b0;
        en_pipe <= 2'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Register first 32 bits
        a0 <= adda[31:0];
        b0 <= addb[31:0];
        carry0 <= sum0[32];
        
        // Pipeline stage 1: Register next 32 bits
        a1 <= adda[63:32];
        b1 <= addb[63:32];
        
        // Compose final result
        result <= {sum1[31:0], sum0[31:0]};
        result[64] <= sum1[32];
        
        // Pipeline enable signal
        en_pipe <= {en_pipe[0], i_en};
        o_en <= en_pipe[1];
    end
end

endmodule