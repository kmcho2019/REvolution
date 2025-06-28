module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // Declare one-hot encoded state signals
  reg [3:0] state, next_state;

  // Output assignment using one-hot encoding
  assign g = (state == 4'b1000) ? 4'b1000 : (state == 4'b0100) ? 4'b0100 : (state == 4'b0010) ? 4'b0010 : 4'b0001;

  // State transition, next-state logic, and state encoding
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= 4'b0001;
    end else begin
      state <= next_state;
    end
  end

  // State logic based on the priorities and FSM behavior
  always @(*) begin
    case(state)
      4'b0001: begin
        next_state = (r[1]) ? 4'b1000 : (r[2]) ? 4'b0100 : (r[3]) ? 4'b0010 : 4'b0001;
      end
      4'b0100: begin
        next_state = (r[2]) ? 4'b0100 : (r[1]) ? 4'b1000 : 4'b0001;
      end
      4'b1000: begin
        next_state = (r[1]) ? 4'b1000 : 4'b0001;
      end
      4'b0010: begin
        next_state = (r[3]) ? 4'b0010 : 4'b0001;
      end
    endcase
  end

endmodule