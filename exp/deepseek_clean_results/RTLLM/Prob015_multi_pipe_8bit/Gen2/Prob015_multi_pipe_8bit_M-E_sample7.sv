module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [15:0] pp [0:7];  // Partial products (pre-shifted)
    
    // Wallace Tree intermediate registers (sum and carry)
    reg [15:0] s1, c1;    // Stage 1 results
    reg [15:0] s2, c2;    // Stage 2 results
    reg [15:0] s3, c3;    // Stage 3 results
    
    // Enable pipeline - matches 5-stage pipeline
    reg [4:0] en_pipe;

    // 3:2 compressor module (full adder)
    function automatic [1:0] compressor;
        input a, b, c;
        begin
            compressor[1] = a ^ b ^ c;         // sum
            compressor[0] = (a & b) | (a & c) | (b & c);  // carry
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            for (integer i = 0; i < 8; i = i+1) pp[i] <= 16'b0;
            s1 <= 16'b0; c1 <= 16'b0;
            s2 <= 16'b0; c2 <= 16'b0;
            s3 <= 16'b0; c3 <= 16'b0;
            en_pipe <= 5'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
        else begin
            // Propagate enable through pipeline
            en_pipe <= {en_pipe[3:0], mul_en_in};
            
            // Stage 0: Register inputs and generate pre-shifted partial products
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            
            // Generate all partial products (pre-shifted)
            for (integer i = 0; i < 8; i = i+1) begin
                pp[i] <= mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
            end
            
            // Stage 1: First level compression (8→6 terms)
            if (en_pipe[0]) begin
                // Compress groups of 3 partial products
                for (integer j = 0; j < 16; j = j+1) begin
                    {s1[j], c1[j+1]} = compressor(pp[0][j], pp[1][j], pp[2][j]);
                    {s2[j], c2[j+1]} = compressor(pp[3][j], pp[4][j], pp[5][j]);
                end
                // Pass remaining terms through
                s3 <= pp[6];
                c3 <= pp[7];
            end
            
            // Stage 2: Second level compression (6→4 terms)
            if (en_pipe[1]) begin
                for (integer j = 0; j < 16; j = j+1) begin
                    {s1[j], c1[j+1]} = compressor(s1[j], c1[j], s2[j]);
                    {s2[j], c2[j+1]} = compressor(c2[j], s3[j], c3[j]);
                end
            end
            
            // Stage 3: Third level compression (4→3 terms)
            if (en_pipe[2]) begin
                for (integer j = 0; j < 16; j = j+1) begin
                    {s1[j], c1[j+1]} = compressor(s1[j], c1[j], s2[j]);
                end
                s2 <= c2;
            end
            
            // Stage 4: Final addition and output
            if (en_pipe[3]) begin
                mul_out <= s1 + c1 + s2;
            end
            
            // Output enable matches final pipeline stage
            mul_en_out <= en_pipe[4];
        end
    end

endmodule