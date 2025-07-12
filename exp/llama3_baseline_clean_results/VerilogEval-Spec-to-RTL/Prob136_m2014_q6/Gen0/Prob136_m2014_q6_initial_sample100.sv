module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// Enum to represent the states
enum logic [2:0] {
  A = 3'b000,
  B = 3'b001,
  C = 3'b010,
  D = 3'b011,
  E = 3'b100,
  F = 3'b101
} current_state, next_state;

// Sequential logic to handle state transitions
always @(posedge clk) begin
  if (reset) begin
    current_state <= A;
  end else begin
    case (current_state)
      A: begin
        if (!w) begin
          current_state <= B;
        end else begin
          current_state <= A;
        end
      end
      B: begin
        if (!w) begin
          current_state <= C;
        end else begin
          current_state <= D;
        end
      end
      C: begin
        if (!w) begin
          current_state <= E;
        end else begin
          current_state <= D;
        end
      end
      D: begin
        if (!w) begin
          current_state <= F;
        end else begin
          current_state <= A;
        end
      end
      E: begin
        if (!w) begin
          current_state <= E;
        end else begin
          current_state <= D;
        end
      end
      F: begin
        if (!w) begin
          current_state <= C;
        end else begin
          current_state <= D;
        end
      end
      default: begin
        current_state <= A;
      end
    endcase
  end
end

// Combinational logic to determine the output z
always @(*) begin
  case (current_state)
    A, B, C, D: z = 0;
    E, F: z = 1;
    default: z = 0;
  endcase
end

endmodule