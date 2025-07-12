module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended shift register with boundary bits
    reg [513:0] extended_q;
    
    // Combinational next state calculation
    wire [511:0] next_q;
    
    // Apply Rule 110 to all bits in parallel
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Each bit looks at its window in the extended register
            // The extended_q indices are offset by 1 to account for left boundary
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];
            
            // Optimized Rule 110 implementation
            assign next_q[i] = (left & ~right) | (~left & (center | right));
        end
    endgenerate
    
    always @(posedge clk) begin
        if (load) begin
            // Load data with boundary bits
            extended_q <= {1'b0, data, 1'b0};
            q <= data;
        end else begin
            // Update extended register with new state and boundaries
            extended_q <= {1'b0, next_q, 1'b0};
            q <= next_q;
        end
    end

endmodule