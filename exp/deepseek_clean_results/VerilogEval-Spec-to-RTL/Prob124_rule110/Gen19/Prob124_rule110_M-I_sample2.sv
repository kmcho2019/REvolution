module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation with optimized logic
    wire [511:0] next_q;
    wire [511:0] change_mask;

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Neighbor selection with optimized boundary handling
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Optimized Rule 110 logic - broken into simpler operations
            wire a = left & ~right;
            wire b = ~left & right;
            wire c = center & ~left;
            assign next_q[i] = a | b | c;
            
            // Change indicator for clock gating
            assign change_mask[i] = (next_q[i] != center);
        end
    endgenerate

    // State transition logic with clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update bits that will change
            for (integer j = 0; j < 512; j = j + 1) begin
                if (change_mask[j]) begin
                    q[j] <= next_q[j];
                end
            end
        end
    end

endmodule