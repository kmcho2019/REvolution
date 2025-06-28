module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  reg [1:0] present_state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      present_state <= 2'b00; // State A
    end else begin
      present_state <= next_state;
    end
  end

  always @* begin
    case (present_state)
      2'b00: begin // A
        next_state = w ? 2'b01 : 2'b00;
        z = 0;
      end
      2'b01: begin // B
        next_state = w ? 2'b10 : 2'b11;
        z = 0;
      end
      2'b10: begin // C
        next_state = w ? 2'b10 : 2'b11;
        z = 0;
      end
      2'b11: begin // D
        next_state = w ? 2'b11 : 2'b00;
        z = 0;
      end
      2'b100: begin // E
        next_state = w ? 2'b100 : 2'b11;
        z = 1;
      end
      2'b101: begin // F
        next_state = w ? 2'b10 : 2'b11;
        z = 1;
      end
    endcase
  end

endmodule