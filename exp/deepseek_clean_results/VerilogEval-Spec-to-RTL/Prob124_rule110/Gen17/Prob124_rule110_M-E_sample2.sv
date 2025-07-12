module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 LUT (3-bit input -> 1-bit output)
    reg [7:0] rule110_lut;
    initial begin
        rule110_lut[0] = 0;  // 000
        rule110_lut[1] = 1;  // 001
        rule110_lut[2] = 1;  // 010
        rule110_lut[3] = 1;  // 011
        rule110_lut[4] = 0;  // 100
        rule110_lut[5] = 1;  // 101
        rule110_lut[6] = 1;  // 110
        rule110_lut[7] = 0;  // 111
    end

    // Pipeline registers
    reg [511:0] q_pipe;

    // Window processing
    always @(*) begin
        // Left boundary (special case)
        q_pipe[511] = rule110_lut[{1'b0, q[511], q[510]}];
        
        // Middle cells
        for (int i = 510; i >= 1; i--) begin
            q_pipe[i] = rule110_lut[{q[i+1], q[i], q[i-1]}];
        end
        
        // Right boundary (special case)
        q_pipe[0] = rule110_lut[{q[1], q[0], 1'b0}];
    end

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_pipe;
        end
    end

endmodule