module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers for neighbor alignment
    reg [511:0] left_neighbors;
    reg [511:0] right_neighbors;

    // Shift registers for neighbor alignment
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            left_neighbors <= {data[510:0], 1'b0};  // q[-1] = 0
            right_neighbors <= {1'b0, data[511:1]};  // q[512] = 0
        end else begin
            // Update neighbors
            left_neighbors <= {q[510:0], 1'b0};
            right_neighbors <= {1'b0, q[511:1]};
            
            // Rule 110 computation using pattern matching
            q <= (~left_neighbors & (q | right_neighbors)) | 
                 (left_neighbors & q & ~right_neighbors) |
                 (left_neighbors & ~q & right_neighbors);
        end
    end

endmodule