module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

  reg [2:0] state, next_state;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000; // Initial state A
    end
    else begin
      state <= next_state;
    end
  end

  always @* begin
    case(state)
      3'b000: begin // State A
        if (w) begin
          next_state = 3'b000;
          z = 1'b0;
        end
        else begin
          next_state = 3'b001;
          z = 1'b1;
        end
      end
      3'b001: begin // State B
        if (w) begin
          next_state = 3'b010;
          z = 1'b0;
        end
        else begin
          next_state = 3'b011;
          z = 1'b1;
        end
      end
      3'b010: begin // State C
        if (w) begin
          next_state = 3'b100;
          z = 1'b0;
        end
        else begin
          next_state = 3'b011;
          z = 1'b1;
        end
      end
      3'b011: begin // State D
        if (w) begin
          next_state = 3'b110;
          z = 1'b0;
        end
        else begin
          next_state = 3'b000;
          z = 1'b1;
        end
      end
      3'b100: begin // State E
        if (w) begin
          next_state = 3'b100;
          z = 1'b1;
        end
        else begin
          next_state = 3'b011;
          z = 1'b1;
        end
      end
      3'b101: begin // State F
        if (w) begin
          next_state = 3'b010;
          z = 1'b1;
        end
        else begin
          next_state = 3'b011;
          z = 1'b1;
        end
      end
    endcase
  end

endmodule