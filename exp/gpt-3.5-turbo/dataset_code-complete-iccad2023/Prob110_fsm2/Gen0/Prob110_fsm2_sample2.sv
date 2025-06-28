module TopModule (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // State definition
  parameter OFF = 2'b00;
  parameter ON = 2'b01;
  
  // State register
  reg [1:0] state, next_state;
  
  // State machine logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end
  
  always @* begin
    case(state)
      OFF: begin
        if (j) begin
          next_state = ON;
          out = 1'b0;
        end else begin
          next_state = OFF;
          out = 1'b0;
        end
      end
      ON: begin
        if (k) begin
          next_state = OFF;
          out = 1'b1;
        end else begin
          next_state = ON;
          out = 1'b1;
        end
      end
    endcase
  end
  
endmodule