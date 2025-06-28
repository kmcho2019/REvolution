module TopModule (
  input clk,
  input areset,
  input x,
  output z
);

  // Define states using one-hot encoding
  reg [1:0] state, next_state;
  `define A 2'b01
  `define B 2'b10

  // State transition and output logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= `A;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    case (state)
      // State A transitions
      `A:
      begin
        if (x == 1) begin
          next_state = `B;
          z = 1;
        end else begin
          next_state = `A;
          z = 0;
        end
      end

      // State B transitions
      `B:
      begin
        if (x == 1) begin
          next_state = `B;
          z = 0;
        end else begin
          next_state = `B;
          z = 1;
        end
      end
    endcase
  end

endmodule