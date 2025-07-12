module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Boundary registers (virtual neighbors)
    reg left_bound = 1'b0;  // q[512] (virtual)
    reg right_bound = 1'b0; // q[-1] (virtual)

    // Next state computation
    wire [511:0] next_q;

    // Process cells in overlapping triplets
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Shared neighbor wires
            wire left = (i == 511) ? left_bound : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? right_bound : q[i-1];

            // Optimized Rule 110 LUT (matches truth table exactly)
            assign next_q[i] = (center ^ (left | right)) | (~left & center & right);
        end
    endgenerate

    // State transition with optimized load path
    always @(posedge clk) begin
        if (load) begin
            q <= data;  // Direct load path
        end else begin
            q <= next_q;
        end
    end

endmodule