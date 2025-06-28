module TopModule (
  input clk,
  input reset,
  input w,
  output reg z
);

// Define state codes
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101;

// State register
reg [2:0] state, next_state;

// State flip-flops
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// State transition and output logic
always @(*) begin
  case (state)
    A: begin
      if (w) begin
        next_state = B;
        z = 1'b0;
      end else begin
        next_state = A;
        z = 1'b0;
      end
    end
    B: begin
      if (w) begin
        next_state = C;
        z = 1'b0;
      end else begin
        next_state = D;
        z = 1'b0;
      end
    end
    C: begin
      if (w) begin
        next_state = E;
        z = 1'b0;
      end else begin
        next_state = D;
        z = 1'b0;
      end
    end
    D: begin
      if (w) begin
        next_state = F;
        z = 1'b0;
      end else begin
        next_state = A;
        z = 1'b0;
      end
    end
    E: begin
      if (w) begin
        next_state = E;
        z = 1'b1;
      end else begin
        next_state = D;
        z = 1'b0;
      end
    end
    F: begin
      if (w) begin
        next_state = C;
        z = 1'b1;
      end else begin
        next_state = D;
        z = 1'b0;
      end
    end
  endcase
end

endmodule