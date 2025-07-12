module TopModule(
  input  clk,
  input  resetn,
  input  [2:0] r,
  output [2:0] g
);

// Define the states
parameter [1:0] A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

// State register
reg [1:0] state, next_state;

// Output logic
assign g[0] = (state == B) & r[0];
assign g[1] = (state == C) & r[1];
assign g[2] = (state == D) & r[2];

// Sequential logic for state update
always @(posedge clk) begin
  if (!resetn) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Combinational logic for next state calculation
always @(*) begin
  case(state)
    A: begin
      if (r[0] == 1'b1) begin
        next_state = B;
      end else if (r[1] == 1'b1) begin
        next_state = C;
      end else if (r[2] == 1'b1) begin
        next_state = D;
      end else begin
        next_state = A;
      end
    end
    B: begin
      if (r[0] == 1'b1) begin
        next_state = B;
      end else begin
        next_state = A;
      end
    end
    C: begin
      if (r[1] == 1'b1) begin
        next_state = C;
      end else begin
        next_state = A;
      end
    end
    default: begin
      next_state = A; // In case D is the current state, reset to A
    end
  endcase
end

endmodule