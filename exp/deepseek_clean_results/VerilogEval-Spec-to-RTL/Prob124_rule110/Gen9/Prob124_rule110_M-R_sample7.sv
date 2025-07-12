module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create extended version of q with zero boundaries
    wire [513:0] extended_q = {1'b0, q, 1'b0};
    
    // Calculate next states using boolean expressions
    wire [511:0] next_q;
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            wire left = extended_q[i+2];    // q[i+1]
            wire center = extended_q[i+1];  // q[i]
            wire right = extended_q[i];    // q[i-1]
            
            // Rule 110: next = right OR (center XOR (left AND center))
            assign next_q[i] = right | (center ^ (left & center));
        end
    endgenerate

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule