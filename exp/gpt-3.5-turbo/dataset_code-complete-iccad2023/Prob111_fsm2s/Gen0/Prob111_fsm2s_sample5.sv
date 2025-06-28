module MooreStateMachine (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // Enum for states
  typedef enum logic [1:0] {
    OFF,
    ON
  } state_type;

  // State register
  reg [1:0] state, next_state;
  
  // State transition and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
    end 
    else begin
      state <= next_state;
    end
  end
  
  always @* begin
    case (state)
      OFF: begin
        if (j) begin
          next_state = ON;
        end 
        else begin
          next_state = OFF;
        end
        out = 1'b0;
      end
      ON: begin
        if (k) begin
          next_state = OFF;
        end 
        else begin
          next_state = ON;
        end
        out = 1'b1;
      end
    endcase
  end

endmodule