module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load)
      q <= data;
    else begin
      reg [511:0] next_q;
      // Handle boundary conditions assuming q[-1] and q[512] are both 0
      next_q[0] = (q[1] == 1 && q[0] == 1) ? 0 :
                  ((q[1] == 1 && q[0] == 0) || (q[1] == 0 && q[0] == 1)) ? 1 : 
                   0;
      next_q[511] = (q[510] == 1 && q[511] == 1) ? 0 :
                    ((q[510] == 1 && q[511] == 0) || (q[510] == 0 && q[511] == 1)) ? 1 : 
                     0;
      // Apply Rule 110 logic for internal cells
      for (int i = 1; i < 511; i = i + 1) begin
        next_q[i] = ((q[i-1] == 1 && q[i] == 1 && q[i+1] == 1) ? 0 :
                     (((q[i-1] == 1) && (q[i] == 1) && (q[i+1] == 0)) || ((q[i-1] == 1) && (q[i] == 0) && (q[i+1] == 1))) ? 1 : 
                      (q[i-1] == 0 && q[i] == 1 && q[i+1] == 0) ? 1 :
                       (q[i-1] == 0 && q[i] == 0 && q[i+1] == 1) ? 1 : 
                        0);
      end
      q <= next_q;
    end
  end

endmodule