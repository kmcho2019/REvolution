module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage0, stage1, stage2, stage3;
    reg [511:0] stage4, stage5, stage6, stage7;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Clear pipeline when loading new data
            stage0 <= 512'b0;
            stage1 <= 512'b0;
            stage2 <= 512'b0;
            stage3 <= 512'b0;
            stage4 <= 512'b0;
            stage5 <= 512'b0;
            stage6 <= 512'b0;
            stage7 <= 512'b0;
        end else begin
            // Stage 0: First 64 bits
            stage0[63:0] <= {1'b0, q[63:1]} ^ {q[62:0], 1'b0};
            
            // Stage 1: Next 64 bits (64-127)
            stage0[127:64] <= {q[64], q[127:65]} ^ {q[126:64], q[63]};
            
            // Stage 2: Next 64 bits (128-191)
            stage0[191:128] <= {q[128], q[191:129]} ^ {q[190:128], q[127]};
            
            // Stage 3: Next 64 bits (192-255)
            stage0[255:192] <= {q[192], q[255:193]} ^ {q[254:192], q[191]};
            
            // Stage 4: Next 64 bits (256-319)
            stage0[319:256] <= {q[256], q[319:257]} ^ {q[318:256], q[255]};
            
            // Stage 5: Next 64 bits (320-383)
            stage0[383:320] <= {q[320], q[383:321]} ^ {q[382:320], q[319]};
            
            // Stage 6: Next 64 bits (384-447)
            stage0[447:384] <= {q[384], q[447:385]} ^ {q[446:384], q[383]};
            
            // Stage 7: Final 64 bits (448-511)
            stage0[511:448] <= {q[448], q[511:449]} ^ {q[510:448], 1'b0};
            
            // Pipeline the results through stages
            stage1 <= stage0;
            stage2 <= stage1;
            stage3 <= stage2;
            stage4 <= stage3;
            stage5 <= stage4;
            stage6 <= stage5;
            stage7 <= stage6;
            q <= stage7;
        end
    end

endmodule