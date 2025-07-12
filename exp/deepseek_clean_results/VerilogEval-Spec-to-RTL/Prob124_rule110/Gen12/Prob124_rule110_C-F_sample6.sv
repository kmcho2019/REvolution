module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute Rule 110 more efficiently
    function automatic rule110;
        input left, center, right;
        begin
            // Simplified logic based on truth table
            rule110 = (left & center & ~right) |  // 110
                      (left & ~center & right) | // 101
                      (~left & center) |         // 011 or 010
                      (~left & right);           // 001
        end
    endfunction

    // Generate next state for each cell
    wire [511:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : cell
            // Handle boundary conditions (q[-1] and q[512] are 0)
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Compute next state using shared function
            assign next_q[i] = rule110(left, q[i], right);
        end
    endgenerate

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule