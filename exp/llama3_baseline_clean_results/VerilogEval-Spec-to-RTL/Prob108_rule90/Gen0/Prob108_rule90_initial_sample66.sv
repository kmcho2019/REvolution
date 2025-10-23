module TopModule (
  input            clk,
  input            load,
  input    [511:0] data,
  output reg [511:0] q
);

  // Load data into the register when load is high
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      // Apply Rule 90 to update the state
      for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        if (i == 0) begin
          left = 1'b0;
          center = q[i];
          if (i == 511) begin
            right = 1'b0;
          end else begin
            right = q[i+1];
          end
        end else if (i == 511) begin
          left = q[i-1];
          center = q[i];
          right = 1'b0;
        end else begin
          left = q[i-1];
          center = q[i];
          right = q[i+1];
        end
        
        // Calculate the next state based on Rule 90
        reg next_state;
        case ({left, center, right})
          3'b111: next_state = 1'b0;
          3'b110: next_state = 1'b1;
          3'b101: next_state = 1'b0;
          3'b100: next_state = 1'b1;
          3'b011: next_state = 1'b1;
          3'b010: next_state = 1'b0;
          3'b001: next_state = 1'b1;
          3'b000: next_state = 1'b0;
          default: next_state = 1'b0;
        endcase
        
        // Update the state
        if (i == 0) begin
          q[0] <= next_state;
        end else if (i == 511) begin
          q[511] <= next_state;
        end else begin
          q[i] <= next_state;
        end
      end
    end
  end

endmodule