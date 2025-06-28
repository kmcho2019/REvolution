module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  reg [1:0] state;
  parameter A = 2'b00;
  parameter B = 2'b01;
  
  // State and count registers
  reg [2:0] w_counter;
  
  // FSM always block
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
      w_counter <= 3'b0;
      z <= 0;
    end else begin
      case(state)
        A: begin
          if (s == 1) begin
            state <= B;
          end
        end
        
        B: begin
          if (w == 1) begin
            w_counter <= w_counter + 1;
          end
          
          if (w_counter == 3) begin
            if (w_counter[1:0] == 2) begin
              z <= 1;
            end else begin
              z <= 0;
            end
            w_counter <= 3'b0; // Reset counter
            state <= A; // Transition back to state A
          end
        end
      endcase
    end
  end
endmodule