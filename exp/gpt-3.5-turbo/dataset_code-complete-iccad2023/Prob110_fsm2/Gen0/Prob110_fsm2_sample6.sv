module MooreStateMachine (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

  // State encoding
  localparam OFF = 0;
  localparam ON = 1;
  
  // State register
  reg [1:0] state, next_state;
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= OFF;
    end else begin
      state <= next_state;
    end
  end
  
  always @* begin
    case (state)
      OFF: begin
        if (j) begin
          next_state = ON;
        end else begin
          next_state = OFF;
        end
        out = 0;
      end
      ON: begin
        if (k) begin
          next_state = OFF;
        end else begin
          next_state = ON;
        end
        out = 1;
      end
    endcase
  end

endmodule