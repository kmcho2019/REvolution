module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] stage1, stage2, stage3, next_q;

    // Stage 1: Process bits in groups of 16 (0-15, 16-31, etc.)
    always @(*) begin
        // Left boundary
        stage1[0] = q[1];
        
        // Middle bits (1-510)
        for (integer i = 1; i < 511; i = i + 1) begin
            stage1[i] = q[i-1] ^ q[i+1];
        end
        
        // Right boundary
        stage1[511] = q[510];
    end

    // Pipeline registers
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            stage2 <= 0;
            stage3 <= 0;
        end else begin
            stage2 <= stage1;
            stage3 <= stage2;
            next_q <= stage3;
            q <= next_q;
        end
    end

endmodule