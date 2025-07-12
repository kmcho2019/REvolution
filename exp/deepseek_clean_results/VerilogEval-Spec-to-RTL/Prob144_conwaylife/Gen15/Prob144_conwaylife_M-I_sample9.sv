module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Pipeline registers
    reg [255:0] q_ff;
    reg [255:0] next_state;
    
    // Precompute row offsets for faster addressing
    wire [255:0] row_offsets;
    generate
        for (genvar i = 0; i < 16; i = i + 1) begin
            assign row_offsets[i*16 +: 16] = i * 16;
        end
    endgenerate

    // Stage 1: Compute partial sums
    reg [255:0][1:0] sum1, sum2, sum3;
    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            integer row_prev = (i-1) & 15;
            integer row_next = (i+1) & 15;
            for (integer j = 0; j < 16; j = j + 1) begin
                integer col_prev = (j-1) & 15;
                integer col_next = (j+1) & 15;
                
                // Partial sums with carry-save
                sum1[i*16+j] = q[row_prev*16 + col_prev] + 
                              q[row_prev*16 + j];
                sum2[i*16+j] = q[row_prev*16 + col_next] + 
                              q[i*16 + col_prev];
                sum3[i*16+j] = q[i*16 + col_next] + 
                              q[row_next*16 + col_prev];
            end
        end
    end

    // Stage 2: Final count and next state
    reg [255:0] stage2_enable;
    always @(*) begin
        for (integer i = 0; i < 16; i = i + 1) begin
            integer row_next = (i+1) & 15;
            for (integer j = 0; j < 16; j = j + 1) begin
                integer idx = i*16 + j;
                // Complete the sum with carry-save
                wire [1:0] sum4 = q[row_next*16 + j] + 
                                 q[row_next*16 + (j+1)&15];
                wire [3:0] count = sum1[idx] + sum2[idx] + 
                                  sum3[idx] + sum4;
                
                // Stability detection
                wire stable = (count == 2) && q[idx];
                wire birth = (count == 3);
                
                // Enable gating
                stage2_enable[idx] = !stable;
                next_state[idx] = birth;
            end
        end
    end

    // Clock-gated sequential update
    always @(posedge clk) begin
        q_ff <= q;  // Pipeline register
        
        if (load) begin
            q <= data;
        end else begin
            for (integer k = 0; k < 256; k = k + 1) begin
                if (stage2_enable[k]) begin
                    q[k] <= next_state[k];
                end
            end
        end
    end

endmodule