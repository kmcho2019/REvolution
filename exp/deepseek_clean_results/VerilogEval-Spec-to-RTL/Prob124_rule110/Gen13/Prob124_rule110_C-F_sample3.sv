module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Generate next state for each bit
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Get neighbors with boundary conditions (0 for out-of-bounds)
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            // Optimized Rule 110 logic - combines all true cases from truth table
            assign next_q[i] = (left & center & ~right) |  // 110
                              (left & ~center & right) |   // 101
                              (~left & center) |           // 011 or 010
                              (~left & right);             // 001
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