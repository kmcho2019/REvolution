module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  reg [1:0] state, next_state;

  // Define the states
  parameter A = 2'b01;
  parameter B = 2'b10;

  // State transition and output logic
  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
      z <= 0;
    end
    else begin
      state <= next_state;
      case (state)
        A: begin
          case (x)
            1: begin
              z <= 1;
              next_state <= B;
            end
            0: begin
              z <= 0;
              next_state <= A;
            end
          endcase
        end
        B: begin
          case (x)
            1: begin
              z <= 0;
              next_state <= B;
            end
            0: begin
              z <= 1;
              next_state <= B;
            end
          endcase
        end
      endcase
    end
  end

endmodule