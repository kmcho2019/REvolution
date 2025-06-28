module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);
  
  // Define the states using one-hot encoding
  reg state_A, state_B;
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1; // Reset into state A
      state_B <= 1'b0;
    end
    else begin
      case ({state_A, state_B})
        2'b00: begin // State A
          if (x) begin
            state_A <= 1'b0;
            state_B <= 1'b1;
          end
        end
        2'b01: begin // State B
          if (x) begin
            state_B <= 1'b0;
          end
        end
      endcase
    end
  end
  
  // Output generation
  always @* begin
    case ({state_A, state_B})
      2'b00: z = 1'b0; // Output is 0 when in state A
      2'b01: z = 1'b1; // Output is 1 when in state B
    endcase
  end
  
endmodule