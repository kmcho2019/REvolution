module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

// Temporary array to hold the next state
reg [511:0] next_q;

always @(posedge clk) begin
    if (load) begin
        // Load initial state
        q <= data;
    end else begin
        // Update next state based on neighbors
        for (int i = 0; i < 512; i = i + 1) begin
            if (i == 0) begin
                // Boundary condition at i = 0
                next_q[0] = q[1] ^ q[0] ^ 0;
            end else if (i == 511) begin
                // Boundary condition at i = 511
                next_q[511] = q[510] ^ q[511] ^ 0;
            end else begin
                // General case
                next_q[i] = q[i-1] ^ q[i] ^ q[i+1];
            end
        end
        // Update current state with next state
        q <= next_q;
    end
end

endmodule