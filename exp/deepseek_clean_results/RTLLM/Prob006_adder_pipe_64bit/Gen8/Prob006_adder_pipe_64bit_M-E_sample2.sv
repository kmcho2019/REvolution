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
reg [63:0] adda_pipe [0:3];
reg [63:0] addb_pipe [0:3];
reg [3:0] carry_pipe;
reg [3:0] en_pipe;

// Intermediate sums and carries
wire [15:0] sum0, sum1, sum2, sum3;
wire carry0, carry1, carry2, carry3;

// Stage 0: bits [15:0]
assign {carry0, sum0} = adda[15:0] + addb[15:0];

// Stage 1: bits [31:16] with carry0
assign {carry1, sum1} = adda_pipe[0][31:16] + addb_pipe[0][31:16] + carry_pipe[0];

// Stage 2: bits [47:32] with carry1
assign {carry2, sum2} = adda_pipe[1][47:32] + addb_pipe[1][47:32] + carry_pipe[1];

// Stage 3: bits [63:48] with carry2
assign {carry3, sum3} = adda_pipe[2][63:48] + addb_pipe[2][63:48] + carry_pipe[2];

always @(posedge clk) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_pipe[0] <= 64'b0;
        adda_pipe[1] <= 64'b0;
        adda_pipe[2] <= 64'b0;
        adda_pipe[3] <= 64'b0;
        addb_pipe[0] <= 64'b0;
        addb_pipe[1] <= 64'b0;
        addb_pipe[2] <= 64'b0;
        addb_pipe[3] <= 64'b0;
        carry_pipe <= 4'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        carry_pipe[0] <= carry0;
        
        // Pipeline stages 1-3
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        carry_pipe[1] <= carry1;
        
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        carry_pipe[2] <= carry2;
        
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        carry_pipe[3] <= carry3;
        
        // Final result composition
        result <= {carry3, sum3, sum2, sum1, sum0};
        
        // Enable signal pipeline (4 stages)
        en_pipe <= {en_pipe[2:0], i_en};
        o_en <= en_pipe[3];
    end
end

endmodule