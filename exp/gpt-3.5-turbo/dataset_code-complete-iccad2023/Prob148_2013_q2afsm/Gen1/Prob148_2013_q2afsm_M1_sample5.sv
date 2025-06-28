module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  reg [3:0] state, next_state;
  reg [2:0] priority;
  
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
          next_state = 4'b0000; // Transition back to state A
        end
      end
      4'b0010: begin // State C
        if (r[2] == 1) begin
          next_state = 4'b0010; // Stay in state C
        end
        else if (r[1] == 1) begin
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
      end
    endcase
  end
  
  always @(*) begin
    priority[1] = (r[1] == 1) ? 1 : 0;
    priority[2] = (r[2] == 1 && ~r[1]) ? 1 : 0;
    priority[3] = (r[3] == 1 && ~r[1] && ~r[2]) ? 1 : 0;
    
    case (priority)
      3'b001: g = 3'b001; // Device 1 granted access
      3'b010: g = 3'b010; // Device 2 granted access
      3'b100: g = 3'b100; // Device 3 granted access
      default: g = 3'b000; // No device granted access
    endcase
  end

endmodule