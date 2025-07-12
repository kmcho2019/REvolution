module TopModule(
  input clk,
  input reset,
  input w,
  output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Current state
reg [2:0] currentState;

// Next state
reg [2:0] nextState;

// Output
reg zReg;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    currentState <= A;
  end else begin
    currentState <= nextState;
  end
end

always @(*) begin
  case (currentState)
    A: begin
      if (w) begin
        nextState = A;
      end else begin
        nextState = B;
      end
    end
    B: begin
      if (w) begin
        nextState = D;
      end else begin
        nextState = C;
      end
    end
    C: begin
      if (w) begin
        nextState = D;
      end else begin
        nextState = E;
      end
    end
    D: begin
      if (w) begin
        nextState = A;
      end else begin
        nextState = F;
      end
    end
    E: begin
      if (w) begin
        nextState = D;
      end else begin
        nextState = E;
      end
    end
    F: begin
      if (w) begin
        nextState = D;
      end else begin
        nextState = C;
      end
    end
    default: nextState = A;
  endcase
end

always @(*) begin
  case (currentState)
    E, F: zReg = 1'b1;
    default: zReg = 1'b0;
  endcase
end

assign z = zReg;

endmodule