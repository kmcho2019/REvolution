module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // States: number of consecutive ones seen
  // 0 = no consecutive ones (previous input was zero)
  // 1..7 = count of consecutive ones
  reg [3:0] state, next_state;

  // Next state logic
  always @(*) begin
    case(state)
      4'd0: begin
        if (in)
          next_state = 4'd1;
        else
          next_state = 4'd0;
      end
      4'd1: begin
        if (in)
          next_state = 4'd2;
        else
          next_state = 4'd0;
      end
      4'd2: begin
        if (in)
          next_state = 4'd3;
        else
          next_state = 4'd0;
      end
      4'd3: begin
        if (in)
          next_state = 4'd4;
        else
          next_state = 4'd0;
      end
      4'd4: begin
        if (in)
          next_state = 4'd5;
        else
          next_state = 4'd0;
      end
      4'd5: begin
        if (in)
          next_state = 4'd6;
        else
          next_state = 4'd0;
      end
      4'd6: begin
        if (in)
          next_state = 4'd7;
        else
          next_state = 4'd0;
      end
      4'd7: begin
        if (in)
          next_state = 4'd7; // stay in error state on 7 or more ones
        else
          next_state = 4'd0;
      end
      default: next_state = 4'd0;
    endcase
  end

  // Sequential logic with synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= 4'd0;
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;
    end else begin
      state <= next_state;
      // Default outputs
      disc <= 1'b0;
      flag <= 1'b0;
      err <= 1'b0;

      // Moore outputs based on current state and input
      // The conditions correspond to last cycle's input pattern:
      // 0111110 => after 5 ones, next bit zero => disc output
      // 01111110 => after 6 ones, next bit zero => flag output
      // 01111111... => 7 or more ones => err output

      case(state)
        4'd5: if (~in) disc <= 1'b1; // 5 ones then zero => discard bit
        4'd6: if (~in) flag <= 1'b1; // 6 ones then zero => flag
        4'd7: err <= 1'b1;            // 7 or more ones => error
      endcase
    end
  end

endmodule