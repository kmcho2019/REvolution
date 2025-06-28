module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  reg [3:0] state, next_state;
  
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= 4'b0000; // Initial state A
    end
    else begin
      state <= next_state;
    end
  end
  
  always @(*) begin
    next_state = state;
    
    case (state)
      4'b0000: begin // State A
        if (r[1] == 1) begin
          next_state = 4'b0001; // Transition to state B
        end
        else if (r[2] == 1) begin
          next_state = 4'b0010; // Transition to state C
        end
        else if (r[3] == 1) begin
          next_state = 4'b0011; // Transition to state D
        end
      end
      4'b0001: begin // State B
        if (r[1] == 1) begin
          next_state = 4'b0001; // Stay in state B
        end
        else if (r[2] == 1) begin
          next_state = 4'b0001; // Stay in state B
        end
        else begin
          next_state = 4'b0000; // Transition back to state A
        end
      end
      4'b0010: begin // State C
        if (r[2] == 1) begin
          next_state = 4'b0010; // Stay in state C
        end
        else if (r[1] == 1) begin
          next_state = 4'b0010; // Stay in state C
        end
        else begin
          next_state = 4'b0000; // Transition back to state A
        end
      end
      4'b0011: begin // State D
        if (r[1] == 1) begin
          next_state = 4'b0011; // Stay in state D
        end
        else if (r[2] == 1) begin
          next_state = 4'b0011; // Stay in state D
        end
        else if (r[3] == 1) begin
          next_state = 4'b0011; // Stay in state D
        end
        else begin
          next_state = 4'b0000; // Transition back to state A
        end
      end
    endcase
  end
  
  // Outputs g[i] assignment
  assign g[1] = (state == 4'b0001) ? 1 : 0; // Device 1 grant
  assign g[2] = (state == 4'b0010) ? 1 : 0; // Device 2 grant
  assign g[3] = (state == 4'b0011) ? 1 : 0; // Device 3 grant

endmodule