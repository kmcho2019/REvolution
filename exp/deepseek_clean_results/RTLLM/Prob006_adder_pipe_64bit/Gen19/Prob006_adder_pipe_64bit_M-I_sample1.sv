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
reg [21:0] sum_pipe [0:2];  // 22/21/21-bit sums with carry
reg [2:0] en_pipe;

// Carry signals
wire carry0 = sum_pipe[0][21];
wire carry1 = sum_pipe[1][20];

// Combinational sums
wire [21:0] sum0 = {1'b0, adda[20:0]} + {1'b0, addb[20:0]};
wire [20:0] sum1 = {1'b0, adda[41:21]} + {1'b0, addb[41:21]} + carry0;
wire [20:0] sum2 = {1'b0, adda[63:42]} + {1'b0, addb[63:42]} + carry1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer i = 0; i < 3; i = i + 1) begin
            sum_pipe[i] <= '0;
        end
        en_pipe <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[1:0], i_en};
        
        // Pipeline stage 0 (22 bits)
        sum_pipe[0] <= sum0;
        
        // Pipeline stage 1 (21 bits)
        sum_pipe[1] <= sum1;
        
        // Pipeline stage 2 (21 bits)
        sum_pipe[2] <= sum2;
        
        // Output result when valid
        if (en_pipe[2]) begin
            result <= {sum_pipe[2][20], 
                      sum_pipe[2][19:0], 
                      sum_pipe[1][19:0], 
                      sum_pipe[0][20:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule