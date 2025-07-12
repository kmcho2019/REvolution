module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Registered version of q to help with timing
    reg [511:0] q_ff;

    // Combinational next state calculation
    wire [511:0] next_q;

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors with boundary conditions (0 for out-of-bound)
            wire left   = (i == 511) ? 1'b0 : q_ff[i+1];
            wire center = q_ff[i];
            wire right  = (i == 0)   ? 1'b0 : q_ff[i-1];
            
            // Optimized Rule 110 logic - single expression
            assign next_q[i] = (center ^ right) | (~left & (center | right));
        end
    endgenerate

    // Two-stage pipeline for better timing
    always @(posedge clk) begin
        if (load) begin
            q_ff <= data;
            q <= data;
        end else begin
            q_ff <= q;
            q <= next_q;
        end
    end

endmodule