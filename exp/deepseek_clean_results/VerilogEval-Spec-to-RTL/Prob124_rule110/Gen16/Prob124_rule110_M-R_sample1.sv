module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create extended version of q with boundary conditions
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Apply Rule 110 to all bits in parallel
            for (integer i = 0; i < 512; i = i + 1) begin
                // Get current neighborhood (left, center, right)
                wire left = extended_q[i+2];
                wire center = extended_q[i+1];
                wire right = extended_q[i];

                // Simplified Rule 110 logic
                q[i] <= (left & center & ~right) |  // 110
                        (left & ~center & right) |  // 101
                        (~left & center) |          // 011 or 010
                        (~left & right);            // 001
            end
        end
    end

endmodule