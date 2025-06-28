module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output reg out
);

always @* begin
  // State transition logic
  case(state)
    4'b0001: begin // State A
      if(in) begin
        next_state = 4'b0010; // Next state B
        out = 0;
      end
      else begin
        next_state = 4'b0001; // Next state A
        out = 0;
      end
    end
    4'b0010: begin // State B
      if(in) begin
        next_state = 4'b0100; // Next state C
        out = 0;
      end
      else begin
        next_state = 4'b0010; // Next state B
        out = 0;
      end
    end
    4'b0100: begin // State C
      if(in) begin
        next_state = 4'b1000; // Next state D
        out = 0;
      end
      else begin
        next_state = 4'b0001; // Next state A
        out = 0;
      end
    end
    4'b1000: begin // State D
      if(in) begin
        next_state = 4'b0100; // Next state C
        out = 1;
      end
      else begin
        next_state = 4'b0010; // Next state B
        out = 0;
      end
    end
  endcase
end

endmodule