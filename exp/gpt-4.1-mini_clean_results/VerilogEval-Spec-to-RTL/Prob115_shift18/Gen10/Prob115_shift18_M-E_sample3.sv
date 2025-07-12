module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    // Intermediate signals for shifts
    reg [63:0] stage1, stage2;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            // Decode amount bits
            // amount[1] = direction: 0 = left, 1 = right
            // amount[0] = shift by 1 (0) or 8 (1)
            
            // Perform shift in two stages to combine shift by 1 and 8
            // We'll split the shift into two operations:
            // If shift by 8, apply 8-bit shift in stage1; else pass through
            // Then if shift by 1, apply 1-bit shift in stage2; else pass through

            // Direction flags
            if (amount[1] == 1'b0) begin
                // Left shifts
                
                // Stage 1: shift by 8 if amount[0] == 1 else no shift
                if (amount[0]) begin
                    // shift left by 8
                    stage1 = {q[55:0], 8'b0};
                end else begin
                    stage1 = q;
                end
                
                // Stage 2: shift left by 1 if amount[0]==0 else no shift
                // Actually, if amount[0]==0, shift by 1 bit; else no shift here
                if (!amount[0]) begin
                    // shift left by 1
                    stage2 = {stage1[62:0], 1'b0};
                end else begin
                    stage2 = stage1;
                end

                q <= stage2;

            end else begin
                // Right arithmetic shifts
                
                // Stage 1: shift right by 8 if amount[0] == 1 else no shift
                if (amount[0]) begin
                    stage1 = {{8{q[63]}}, q[63:8]};
                end else begin
                    stage1 = q;
                end

                // Stage 2: shift right by 1 if amount[0]==0 else no shift
                if (!amount[0]) begin
                    stage2 = {stage1[63], stage1[63:1]};
                end else begin
                    stage2 = stage1;
                end

                q <= stage2;
            end
        end
        // else hold q
    end

endmodule