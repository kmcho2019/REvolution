module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage [0:7];
    reg [511:0] next_stage [0:7];
    
    integer i, j;

    always @(*) begin
        // Stage 0: Compute first 64 bits
        for (i = 0; i < 64; i = i + 1) begin
            reg left, center, right;
            center = q[i];
            left = (i == 63) ? 1'b0 : q[i+1];
            right = (i == 0) ? 1'b0 : q[i-1];
            
            case ({left, center, right})
                3'b111: next_stage[0][i] = 1'b0;
                3'b110: next_stage[0][i] = 1'b1;
                3'b101: next_stage[0][i] = 1'b1;
                3'b100: next_stage[0][i] = 1'b0;
                3'b011: next_stage[0][i] = 1'b1;
                3'b010: next_stage[0][i] = 1'b1;
                3'b001: next_stage[0][i] = 1'b1;
                3'b000: next_stage[0][i] = 1'b0;
            endcase
        end

        // Stages 1-7: Compute remaining bits using previous stage results
        for (j = 1; j < 8; j = j + 1) begin
            for (i = 0; i < 64; i = i + 1) begin
                reg left, center, right;
                center = stage[j-1][64*j + i];
                left = (i == 63 && j == 7) ? 1'b0 : 
                       (i == 63) ? stage[j-1][64*(j+1)] : 
                       stage[j-1][64*j + i + 1];
                right = (i == 0 && j == 0) ? 1'b0 : 
                        (i == 0) ? stage[j-1][64*j - 1] : 
                        stage[j-1][64*j + i - 1];
                
                case ({left, center, right})
                    3'b111: next_stage[j][64*j + i] = 1'b0;
                    3'b110: next_stage[j][64*j + i] = 1'b1;
                    3'b101: next_stage[j][64*j + i] = 1'b1;
                    3'b100: next_stage[j][64*j + i] = 1'b0;
                    3'b011: next_stage[j][64*j + i] = 1'b1;
                    3'b010: next_stage[j][64*j + i] = 1'b1;
                    3'b001: next_stage[j][64*j + i] = 1'b1;
                    3'b000: next_stage[j][64*j + i] = 1'b0;
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Clear pipeline on load
            for (j = 0; j < 8; j = j + 1)
                stage[j] <= 512'b0;
        end else begin
            // Pipeline update
            for (j = 0; j < 7; j = j + 1)
                stage[j+1] <= stage[j];
            stage[0] <= next_stage[0];
            
            // Final output comes from last pipeline stage
            q <= next_stage[7];
        end
    end

endmodule