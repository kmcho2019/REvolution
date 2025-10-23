module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers for each 16-bit stage
reg [15:0] a [0:3];
reg [15:0] b [0:3];
reg carry [0:2];  // Carry between stages
reg [3:0] en_pipe; // Enable pipeline

// Intermediate sums
wire [16:0] sum [0:3];

// Stage 0: Add first 16 bits (no carry in)
assign sum[0] = {1'b0, a[0]} + {1'b0, b[0]};

// Stage 1: Add next 16 bits with carry
assign sum[1] = {1'b0, a[1]} + {1'b0, b[1]} + {16'd0, carry[0]};

// Stage 2: Add next 16 bits with carry
assign sum[2] = {1'b0, a[2]} + {1'b0, b[2]} + {16'd0, carry[1]};

// Stage 3: Add final 16 bits with carry
assign sum[3] = {1'b0, a[3]} + {1'b0, b[3]} + {16'd0, carry[2]};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a[0] <= 0; a[1] <= 0; a[2] <= 0; a[3] <= 0;
        b[0] <= 0; b[1] <= 0; b[2] <= 0; b[3] <= 0;
        carry[0] <= 0; carry[1] <= 0; carry[2] <= 0;
        en_pipe <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Stage 0 registers
        a[0] <= adda[15:0];
        b[0] <= addb[15:0];
        carry[0] <= sum[0][16];
        
        // Stage 1 registers
        a[1] <= adda[31:16];
        b[1] <= addb[31:16];
        carry[1] <= sum[1][16];
        
        // Stage 2 registers
        a[2] <= adda[47:32];
        b[2] <= addb[47:32];
        carry[2] <= sum[2][16];
        
        // Stage 3 registers
        a[3] <= adda[63:48];
        b[3] <= addb[63:48];
        
        // Compose final 65-bit result (1-bit carry + 64-bit sum)
        result <= {sum[3][16], sum[3][15:0], sum[2][15:0], sum[1][15:0], sum[0][15:0]};
        
        // Pipeline enable signal
        en_pipe <= {en_pipe[2:0], i_en};
        o_en <= en_pipe[3];
    end
end

endmodule