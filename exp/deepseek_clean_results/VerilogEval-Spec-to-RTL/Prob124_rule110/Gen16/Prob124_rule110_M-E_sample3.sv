module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extended register to include boundary conditions
    reg [513:0] extended_q;

    // Next state computation
    wire [511:0] next_q;

    // Boundary conditions (q[-1] and q[512] are always 0)
    always @(*) begin
        extended_q[513:512] = 2'b00;  // Right boundary
        extended_q[0] = 1'b0;          // Left boundary
        extended_q[512:1] = q;         // Main 512 bits
    end

    // Compute next state in parallel
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Neighbors are naturally aligned in extended_q
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];

            // Optimized Rule 110 logic
            assign next_q[i] = (center & (left | right)) | (~left & right);
        end
    endgenerate

    // State transition
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule