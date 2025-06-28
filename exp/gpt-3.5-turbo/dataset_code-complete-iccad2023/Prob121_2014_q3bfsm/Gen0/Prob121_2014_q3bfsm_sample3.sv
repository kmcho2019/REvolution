module TopModule (
  input clk,
  input reset,
  input x,
  output reg z
);

  reg [2:0] present_state, next_state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      present_state <= 3'b000;
    end else begin
      present_state <= next_state;
    end

    case (present_state)
      3'b000: begin
        if (x == 1) begin
          next_state = 3'b001;
        end else begin
          next_state = 3'b000;
        end
        z = 0;
      end

      3'b001: begin
        if (x == 1) begin
          next_state = 3'b100;
        end else begin
          next_state = 3'b001;
        end
        z = 0;
      end

      3'b010: begin
        if (x == 1) begin
          next_state = 3'b001;
        end else begin
          next_state = 3'b010;
        end
        z = 0;
      end

      3'b011: begin
        if (x == 1) begin
          next_state = 3'b010;
          z = 1;
        end else begin
          next_state = 3'b001;
          z = 0;
        end
      end

      3'b100: begin
        if (x == 1) begin
          next_state = 3'b100;
          z = 1;
        end else begin
          next_state = 3'b011;
          z = 0;
        end
      end
    endcase
  end

endmodule