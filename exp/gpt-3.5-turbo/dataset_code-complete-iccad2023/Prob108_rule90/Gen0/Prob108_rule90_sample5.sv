module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Define temporary array to store next state
  reg [511:0] next_q;

  always @(posedge clk) begin
    if (load) begin
      // Load initial data
      q <= data;
    end else begin
      // Compute next state
      // Boundary condition: q[-1] and q[512] are always considered 0
      next_q[0] = q[1] ^ q[0];
      next_q[511] = q[510] ^ q[511];
      
      // Compute next state for inner cells
      genvar i;
      generate
        for (i = 1; i < 511; i=i+1) begin : compute_next_state
          always @* begin
            next_q[i] = q[i-1] ^ q[i+1];
          end
        end
      endgenerate
      
      // Update current state
      q <= next_q;
    end
  end

endmodule