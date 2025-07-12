module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended register for boundary conditions
    reg [513:0] q_ext;
    always @(*) begin
        q_ext[512:1] = q;
        q_ext[0] = 1'b0;    // Right boundary (q[-1])
        q_ext[513] = 1'b0;  // Left boundary (q[512])
    end

    // Clock gating logic
    wire clk_gated;
    assign clk_gated = clk & (~load);

    // Pipeline registers for next state calculation
    reg [511:0] next_q_stage1, next_q_stage2;

    // Generate next state for each bit (pipelined)
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Stage 1: Get neighbors (registered)
            always @(posedge clk) begin
                next_q_stage1[i] <= (q_ext[i+2] & (q_ext[i+1] ^ q_ext[i])) | 
                                   (~q_ext[i+2] & (q_ext[i+1] | q_ext[i]));
            end

            // Stage 2: Final registered output
            always @(posedge clk) begin
                next_q_stage2[i] <= next_q_stage1[i];
            end
        end
    endgenerate

    // State transition logic with clock gating
    always @(posedge clk_gated or posedge clk) begin
        if (clk) begin  // Only when clk is high (load case)
            if (load) begin
                q <= data;
            end
        end else begin  // Gated clock case
            q <= next_q_stage2;
        end
    end

endmodule