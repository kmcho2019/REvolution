module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// 3-stage pipeline (22+22+20 bits)
reg [63:0] a_pipe [0:2];
reg [63:0] b_pipe [0:2];
reg [22:0] sum_pipe [0:2]; // 22-bit sum + carry
reg [2:0] en_pipe;

// Combinational sums
wire [22:0] sum0 = {1'b0, adda[21:0]} + {1'b0, addb[21:0]};
wire [22:0] sum1 = {1'b0, a_pipe[0][43:22]} + {1'b0, b_pipe[0][43:22]} + sum_pipe[0][22];
wire [20:0] sum2 = {1'b0, a_pipe[1][63:44]} + {1'b0, b_pipe[1][63:44]} + sum_pipe[1][22];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all registers
        a_pipe[0] <= 64'b0;
        a_pipe[1] <= 64'b0;
        a_pipe[2] <= 64'b0;
        b_pipe[0] <= 64'b0;
        b_pipe[1] <= 64'b0;
        b_pipe[2] <= 64'b0;
        sum_pipe[0] <= 23'b0;
        sum_pipe[1] <= 23'b0;
        sum_pipe[2] <= 23'b0;
        en_pipe <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Enable pipeline (shift register)
        en_pipe <= {en_pipe[1:0], i_en};
        
        // Stage 0: First 22 bits
        if (i_en) begin
            a_pipe[0] <= adda;
            b_pipe[0] <= addb;
            sum_pipe[0] <= sum0;
        end
        
        // Stage 1: Next 22 bits
        if (en_pipe[0]) begin
            a_pipe[1] <= a_pipe[0];
            b_pipe[1] <= b_pipe[0];
            sum_pipe[1] <= sum1;
        end
        
        // Stage 2: Final 20 bits + output
        if (en_pipe[1]) begin
            a_pipe[2] <= a_pipe[1];
            b_pipe[2] <= b_pipe[1];
            sum_pipe[2] <= {sum2, sum_pipe[1][21:0]};
        end
        
        // Output stage
        if (en_pipe[2]) begin
            result <= {sum_pipe[2][22], 
                      sum_pipe[2][21:0], 
                      sum_pipe[1][21:0], 
                      sum_pipe[0][21:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule