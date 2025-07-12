module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Clock gating for power optimization
    wire gated_clk;
    assign gated_clk = clk & (load | (|q) | (|data));  // Only clock when needed

    // Next state logic
    always @(posedge gated_clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Process in chunks to help synthesis
            for (integer i = 0; i < 512; i = i + 1) begin
                // Handle boundaries by concatenation
                reg left, right;
                left = (i == 511) ? 1'b0 : q[i+1];
                right = (i == 0) ? 1'b0 : q[i-1];
                
                // Optimized Rule 110 logic
                q[i] <= (left & (q[i] ^ right)) | (~left & (q[i] | right));
            end
        end
    end

endmodule