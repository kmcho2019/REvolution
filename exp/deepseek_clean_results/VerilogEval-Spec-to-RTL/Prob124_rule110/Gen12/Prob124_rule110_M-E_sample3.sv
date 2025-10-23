module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Triple buffer for neighbor access
    reg [511:0] q_left, q_right;
    
    // Shift operations (circular shifts with implicit zero boundaries)
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            q_left <= {data[510:0], 1'b0};  // Left neighbor (shift left)
            q_right <= {1'b0, data[511:1]}; // Right neighbor (shift right)
        end else begin
            // Compute next state in parallel
            q <= (~q_left & (q | q_right)) | (q_left & q & ~q_right);
            
            // Update shifted versions for next cycle
            q_left <= {q[510:0], 1'b0};
            q_right <= {1'b0, q[511:1]};
        end
    end

endmodule