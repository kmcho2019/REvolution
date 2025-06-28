module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // Declare state signals
  reg [1:0] state, next_state;

  // State encoding
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

  // Synchronize reset signal
  reg reset_sync;
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      reset_sync <= 1'b0;
    end else begin
      reset_sync <= 1'b1;
    end
  end

  // State transition, synchronization, and output assignment
  always @(posedge clk) begin
    if (reset_sync) begin
      state <= A;
    end else begin
      state <= next_state;
    end

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

    // Output assignment based on state
    g[1] <= (state == B);
    g[2] <= (state == C);
    g[3] <= (state == D);
  end

endmodule