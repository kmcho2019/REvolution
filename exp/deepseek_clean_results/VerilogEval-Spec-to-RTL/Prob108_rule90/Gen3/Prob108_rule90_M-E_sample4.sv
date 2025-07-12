module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Temporary extended register with boundary conditions
reg [513:0] temp_q;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        // Set boundary conditions (q[-1] and q[512] are 0)
        temp_q[513:1] <= {1'b0, q, 1'b0};
        
        // Apply Rule 90 to all cells simultaneously
        for (integer i = 0; i < 512; i = i + 1) begin
            q[i] <= temp_q[i] ^ temp_q[i+2];  // XOR of left and right neighbors
        end
    end
end

endmodule