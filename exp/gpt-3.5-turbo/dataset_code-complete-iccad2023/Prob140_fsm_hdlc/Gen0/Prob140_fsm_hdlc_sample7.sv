module HDLC_FSM (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // Define states
  parameter SEARCH_0111110 = 2'b00;
  parameter SEARCH_01111110 = 2'b01;
  parameter ERROR = 2'b10;

  // Define internal signals
  reg [1:0] state, next_state;
  reg [2:0] count;

  // Outputs
  assign disc = (state == SEARCH_0111110);
  assign flag = (state == SEARCH_01111110);
  assign err = (state == ERROR);

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= SEARCH_0111110;
      count <= 0;
    end
    else begin
      state <= next_state;
      count <= (in) ? count + 1 : 0;
    end
  end

  always @* begin
    case (state)
      SEARCH_0111110: begin
        if (in) begin
          if (count == 5)
            next_state = SEARCH_0111110;
          else
            next_state = SEARCH_0111110;
        end
        else begin
          next_state = SEARCH_01111110;
        end
      end
      SEARCH_01111110: begin
        if (in) begin
          if (count == 6)
            next_state = ERROR;
          else
            next_state = SEARCH_0111110;
        end
        else begin
          next_state = SEARCH_0111110;
        end
      end
      ERROR: begin
        next_state = SEARCH_0111110;
      end
      default: begin
        next_state = SEARCH_01111110;
      end
    endcase
  end

endmodule