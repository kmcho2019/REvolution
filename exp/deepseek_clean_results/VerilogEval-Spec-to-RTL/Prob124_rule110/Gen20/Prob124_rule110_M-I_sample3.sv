module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Registered neighbor bits to break critical path
    reg [511:0] q_reg;
    wire [513:0] extended_q = {1'b0, q_reg, 1'b0};

    // Combinational next state calculation
    wire [511:0] next_q;

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors from registered version with boundary conditions
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];

            // Optimized Rule 110 logic - 3 OR terms
            assign next_q[i] = (center & (left | ~right)) |  // Covers 110, 011, 010
                              (~center & left & right) |     // Covers 101
                              (~left & right);              // Covers 001
                              // All other cases -> 0
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        q_reg <= q;  // Register current state for neighbor selection
        
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule