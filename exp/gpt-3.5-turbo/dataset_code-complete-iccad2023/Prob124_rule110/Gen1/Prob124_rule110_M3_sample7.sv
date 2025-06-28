module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @* begin
    if (load) begin
      q <= data; // Load data when load is active
    end 
    else begin
        reg [511:0] next_q;
        
        // Implement Rule 110 concurrently for all cells
        generate
            genvar i;
            for (i = 0; i < 512; i = i + 1) begin : rule110
                always @* begin
                    int left = (i == 0) ? 0 : q[i-1];
                    int right = (i == 511) ? 0 : q[i+1];
                    
                    case({left, q[i], right})
                        3'b111: next_q[i] = 0;
                        3'b110: next_q[i] = 1;
                        3'b101: next_q[i] = 1;
                        3'b100: next_q[i] = 0;
                        3'b011: next_q[i] = 1;
                        3'b010: next_q[i] = 1;
                        3'b001: next_q[i] = 1;
                        3'b000: next_q[i] = 0;
                    endcase
                end
            end
        endgenerate
        
        q <= next_q; // Update all cell states simultaneously
    end
  end

endmodule