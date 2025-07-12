module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [65:0] stage1_in, stage1_out;
    reg [65:0] stage2_in, stage2_out;
    reg [65:0] stage3_in, stage3_out;
    reg [65:0] stage4_in, stage4_out;
    reg [65:0] stage5_in, stage5_out;
    reg [65:0] stage6_in, stage6_out;
    reg [65:0] stage7_in, stage7_out;
    reg [65:0] stage8_in, stage8_out;

    // Combinational next state calculation for each stage
    function [63:0] rule110_chunk;
        input [65:0] window;
        integer i;
        begin
            for (i = 0; i < 64; i = i + 1) begin
                rule110_chunk[i] = (window[i+1] ^ (window[i+2] & window[i])) | (~window[i+2] & window[i]);
            end
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
            // Reset pipeline when loading new data
            stage1_in <= {2'b0, data[63:0]};
            stage2_in <= {data[63:62], data[127:64]};
            stage3_in <= {data[127:126], data[191:128]};
            stage4_in <= {data[191:190], data[255:192]};
            stage5_in <= {data[255:254], data[319:256]};
            stage6_in <= {data[319:318], data[383:320]};
            stage7_in <= {data[383:382], data[447:384]};
            stage8_in <= {data[447:446], data[511:448], 2'b0};
        end else begin
            // Pipeline stage 1 (bits 0-63)
            stage1_out <= {2'b0, rule110_chunk(stage1_in)};
            stage1_in <= {stage1_out[65:64], q[127:64]};

            // Pipeline stage 2 (bits 64-127)
            stage2_out <= {stage1_out[63:62], rule110_chunk(stage2_in)};
            stage2_in <= {stage2_out[65:64], q[191:128]};

            // Pipeline stage 3 (bits 128-191)
            stage3_out <= {stage2_out[63:62], rule110_chunk(stage3_in)};
            stage3_in <= {stage3_out[65:64], q[255:192]};

            // Pipeline stage 4 (bits 192-255)
            stage4_out <= {stage3_out[63:62], rule110_chunk(stage4_in)};
            stage4_in <= {stage4_out[65:64], q[319:256]};

            // Pipeline stage 5 (bits 256-319)
            stage5_out <= {stage4_out[63:62], rule110_chunk(stage5_in)};
            stage5_in <= {stage5_out[65:64], q[383:320]};

            // Pipeline stage 6 (bits 320-383)
            stage6_out <= {stage5_out[63:62], rule110_chunk(stage6_in)};
            stage6_in <= {stage6_out[65:64], q[447:384]};

            // Pipeline stage 7 (bits 384-447)
            stage7_out <= {stage6_out[63:62], rule110_chunk(stage7_in)};
            stage7_in <= {stage7_out[65:64], q[511:448], 1'b0};

            // Pipeline stage 8 (bits 448-511)
            stage8_out <= {stage7_out[63:62], rule110_chunk(stage8_in)};
            stage8_in <= {1'b0, stage8_out[65:2]};

            // Combine all pipeline outputs
            q <= {stage8_out[63:0], stage7_out[63:0], stage6_out[63:0], 
                  stage5_out[63:0], stage4_out[63:0], stage3_out[63:0],
                  stage2_out[63:0], stage1_out[63:0]};
        end
    end

endmodule