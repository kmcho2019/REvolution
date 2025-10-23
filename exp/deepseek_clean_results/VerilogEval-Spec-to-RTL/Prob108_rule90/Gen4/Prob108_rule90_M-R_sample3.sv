module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    
    // Combinational logic for Rule 90
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin: rule90
            // Left neighbor: q[i-1] or 0 if at left boundary
            wire left = (i == 0) ? 1'b0 : q[i-1];
            // Right neighbor: q[i+1] or 0 if at right boundary
            wire right = (i == 511) ? 1'b0 : q[i+1];
            // Rule 90: next state is XOR of neighbors
            assign next_q[i] = left ^ right;
        end
    endgenerate
    
    // Synchronous update
    always @(posedge clk) begin
        if (load) begin
            q <= data;  // Load new state
        end else begin
            q <= next_q;  // Update to next state
        end
    end

endmodule