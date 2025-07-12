module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [511:0] left_neighbors;
    reg [511:0] right_neighbors;
    
    // Shift register approach for neighbor capture
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Stage 1: Capture neighbors (shift operations)
            left_neighbors <= {1'b0, q[511:1]};  // Left neighbors (q[-1] = 0)
            right_neighbors <= {q[510:0], 1'b0};  // Right neighbors (q[512] = 0)
            
            // Stage 2: Compute XOR (registered for pipelining)
            q <= left_neighbors ^ right_neighbors;
        end
    end

endmodule