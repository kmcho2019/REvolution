module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Clock gating logic
    wire clk_en = load | (|q);  // Enable clock when load or any q bit is active
    wire gated_clk = clk & clk_en;

    // Virtual boundary registers
    reg left_bound = 1'b0;
    reg right_bound = 1'b0;

    // Pipeline registers
    reg [511:0] q_pipe;
    wire [511:0] next_q;

    // Combinational logic for Rule 90 with pipelining
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            // Left neighbor: q[i-1] or virtual boundary if at left boundary
            wire left = (i == 0) ? left_bound : q[i-1];
            // Right neighbor: q[i+1] or virtual boundary if at right boundary
            wire right = (i == 511) ? right_bound : q[i+1];
            // Rule 90: next state is XOR of neighbors
            assign next_q[i] = left ^ right;
        end
    endgenerate

    // Synchronous update with pipeline
    always @(posedge gated_clk) begin
        if (load) begin
            q <= data;          // Load new state
            q_pipe <= 512'b0;   // Reset pipeline
        end else begin
            q_pipe <= next_q;   // First pipeline stage
            q <= q_pipe;        // Second pipeline stage
        end
    end

endmodule