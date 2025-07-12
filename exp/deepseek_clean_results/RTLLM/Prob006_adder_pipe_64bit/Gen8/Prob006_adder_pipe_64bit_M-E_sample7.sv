module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Gray-coded enable pipeline
reg [3:0] en_pipe;
wire [3:0] next_en_pipe = {en_pipe[2:0], i_en};

// Pipeline stage 1: Carry-select pre-computation
reg [15:0] a0, a1, a2, a3, b0, b1, b2, b3;
reg [16:0] sum0_0, sum0_1, sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1;

// Pipeline stage 2: Carry selection
reg [16:0] sum0, sum1, sum2, sum3;
reg carry1, carry2, carry3;

// Pipeline stage 3: Intermediate combination
reg [33:0] sum_low;
reg [32:0] sum_high;

// Gray code conversion functions
function [3:0] binary_to_gray;
    input [3:0] binary;
    binary_to_gray = binary ^ (binary >> 1);
endfunction

function [3:0] gray_to_binary;
    input [3:0] gray;
    gray_to_binary = {gray[3], 
                     gray[3] ^ gray[2],
                     gray[3] ^ gray[2] ^ gray[1],
                     gray[3] ^ gray[2] ^ gray[1] ^ gray[0]};
endfunction

// Pipeline stage 1: Pre-compute sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {a0, a1, a2, a3, b0, b1, b2, b3} <= 128'b0;
        {sum0_0, sum0_1, sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1} <= 136'b0;
    end else if (i_en) begin
        // Slice operands into 16-bit chunks
        a0 <= adda[15:0];   b0 <= addb[15:0];
        a1 <= adda[31:16];  b1 <= addb[31:16];
        a2 <= adda[47:32];  b2 <= addb[47:32];
        a3 <= adda[63:48];  b3 <= addb[63:48];
        
        // Pre-compute sums for both carry possibilities
        sum0_0 <= {1'b0, a0} + {1'b0, b0};
        sum0_1 <= {1'b0, a0} + {1'b0, b0} + 17'h1;
        sum1_0 <= {1'b0, a1} + {1'b0, b1};
        sum1_1 <= {1'b0, a1} + {1'b0, b1} + 17'h1;
        sum2_0 <= {1'b0, a2} + {1'b0, b2};
        sum2_1 <= {1'b0, a2} + {1'b0, b2} + 17'h1;
        sum3_0 <= {1'b0, a3} + {1'b0, b3};
        sum3_1 <= {1'b0, a3} + {1'b0, b3} + 17'h1;
    end
end

// Pipeline stage 2: Carry selection
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {sum0, sum1, sum2, sum3} <= 68'b0;
        {carry1, carry2, carry3} <= 3'b0;
    end else begin
        // Select correct sum based on previous carry
        sum0 <= sum0_0; // First chunk never has incoming carry
        sum1 <= sum0[16] ? sum1_1 : sum1_0;
        sum2 <= carry1 ? sum2_1 : sum2_0;
        sum3 <= carry2 ? sum3_1 : sum3_0;
        
        // Store carries for next stage
        carry1 <= sum0[16];
        carry2 <= sum1[16];
        carry3 <= sum2[16];
    end
end

// Pipeline stage 3: Intermediate combination
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low <= 34'b0;
        sum_high <= 33'b0;
    end else begin
        sum_low <= {sum1[15:0], sum0[15:0]};
        sum_high <= {sum3[15:0], sum2[15:0], carry3};
    end
end

// Pipeline stage 4: Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
        en_pipe <= 4'b0;
    end else begin
        // Gray-coded enable pipeline
        en_pipe <= binary_to_gray(next_en_pipe);
        
        // Final result assembly
        if (gray_to_binary(en_pipe)[3]) begin
            result <= {sum_high[32], sum_high[31:0], sum_low[31:0]};
        end
        o_en <= gray_to_binary(en_pipe)[3];
    end
end

endmodule