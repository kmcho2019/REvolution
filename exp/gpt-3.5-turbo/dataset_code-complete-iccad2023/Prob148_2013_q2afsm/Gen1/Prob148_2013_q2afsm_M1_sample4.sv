module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

  // Declare state signals
  reg [1:0] state, next_state;

  // State encoding
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

  // State transition and logic
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // State logic based on the state diagram
  always @(state, r) begin
    case(state)
      A: begin
        if (r[1]) next_state = B;
        else if (r[2]) next_state = C;
        else if (r[3]) next_state = D;
        else next_state = A;
      end
      B: begin
        if (r[1]) next_state = B;
        else next_state = A;
      end
      C: begin
        if (r[2]) next_state = C;
        else next_state = A;
      end
      D: begin
        if (r[3]) next_state = D;
        else next_state = A;
      end
      default: next_state = A;
    endcase
  end

  // Output assignment based on the FSM states
  always @(*) begin
    case(state)
      A: begin
        g[1] = 1'b0;
        g[2] = 1'b0;
        g[3] = 1'b0;
      end
      B: begin
        g[1] = 1'b1;
        g[2] = 1'b0;
        g[3] = 1'b0;
      end
      C: begin
        g[1] = 1'b0;
        g[2] = 1'b1;
        g[3] = 1'b0;
      end
      D: begin
        g[1] = 1'b0;
        g[2] = 1'b0;
        g[3] = 1'b1;
      end
      default: begin
        g[1] = 1'b0;
        g[2] = 1'b0;
        g[3] = 1'b0;
      end
    endcase
  end

endmodule