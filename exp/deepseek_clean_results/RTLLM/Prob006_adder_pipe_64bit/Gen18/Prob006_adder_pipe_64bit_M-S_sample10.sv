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
reg [63:0] a_pipe [0:3];
reg [63:0] b_pipe [0:3];
reg [16:0] sum_pipe [0:3];  // 16-bit sum + carry
reg [3:0] en_pipe;

// Carry signals
wire carry0 = sum_pipe[0][16];
wire carry1 = sum_pipe[1][16];
wire carry2 = sum_pipe[2][16];

// Combinational sums
wire [16:0] sum0 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
wire [16:0] sum1 = {1'b0, a_pipe[0][31:16]} + {1'b0, b_pipe[0][31:16]} + carry0;
wire [16:0] sum2 = {1'b0, a_pipe[1][47:32]} + {1'b0, b_pipe[1][47:32]} + carry1;
wire [16:0] sum3 = {1'b0, a_pipe[2][63:48]} + {1'b0, b_pipe[2][63:48]} + carry2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer i = 0; i < 4; i = i + 1) begin
            a_pipe[i] <= 64'b0;
            b_pipe[i] <= 64'b0;
            sum_pipe[i] <= 17'b0;
        end
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[2:0], i_en};
        
        // Pipeline stage 0
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        sum_pipe[0] <= sum0;
        
        // Pipeline stage 1
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        sum_pipe[1] <= sum1;
        
        // Pipeline stage 2
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        sum_pipe[2] <= sum2;
        
        // Pipeline stage 3 (output)
        a_pipe[3] <= a_pipe[2];
        b_pipe[3] <= b_pipe[2];
        sum_pipe[3] <= sum3;
        
        // Output result when valid
        if (en_pipe[3]) begin
            result <= {sum_pipe[3][16], 
                      sum_pipe[3][15:0], 
                      sum_pipe[2][15:0], 
                      sum_pipe[1][15:0], 
                      sum_pipe[0][15:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule