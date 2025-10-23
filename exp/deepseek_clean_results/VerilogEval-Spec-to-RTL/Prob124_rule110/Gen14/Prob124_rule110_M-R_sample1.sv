module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create extended version with boundary conditions
    wire [513:0] extended_q = {1'b0, q, 1'b0};

    // Next state calculation
    wire [511:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            // Neighbors from extended version
            wire left = extended_q[i+2];
            wire center = extended_q[i+1];
            wire right = extended_q[i];

            // Optimized Rule 110 logic
            assign next_q[i] = ~(left & center & right) & 
                             ((left & center) | (center & right) | (left & right) | (~left & right));
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