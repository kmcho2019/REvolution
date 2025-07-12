module TopModule(
  input clk,
  input resetn,
  input [2:0] r,
  output [2:0] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define current and next states
reg [1:0] current_state;
reg [1:0] next_state;

// Update state flip-flops
always @(posedge clk) begin
  if (!resetn) begin
    current_state <= A;
  end else begin
    current_state <= next_state;
  end
end

// Describe state table
always @(*) begin
  case (current_state)
    A: begin
      if (r[0] == 1'b1) begin
        next_state <= B;
      end else if (r[0] == 1'b0 && r[1] == 1'b1) begin
        next_state <= C;
      end else if (r[0] == 1'b0 && r[1] == 1'b0 && r[2] == 1'b1) begin
        next_state <= D;
      end else begin
        next_state <= A;
      end
    end
    B: begin
      if (r[0] == 1'b1) begin
        next_state <= B;
      end else begin
        next_state <= A;
      end
    end
    C: begin
      if (r[1] == 1'b1) begin
        next_state <= C;
      end else begin
        next_state <= A;
      end
    end
    D: begin
      if (r[2] == 1'b1) begin
        next_state <= D;
      end else begin
        next_state <= A;
      end
    end
    default: next_state <= A;
  endcase
end

// Describe FSM outputs
always @(*) begin
  case (current_state)
    A: begin
      g[0] <= 1'b0;
      g[1] <= 1'b0;
      g[2] <= 1'b0;
    end
    B: begin
      g[0] <= 1'b1;
      g[1] <= 1'b0;
      g[2] <= 1'b0;
    end
    C: begin
      g[0] <= 1'b0;
      g[1] <= 1'b1;
      g[2] <= 1'b0;
    end
    D: begin
      g[0] <= 1'b0;
      g[1] <= 1'b0;
      g[2] <= 1'b1;
    end
    default: begin
      g[0] <= 1'b0;
      g[1] <= 1'b0;
      g[2] <= 1'b0;
    end
  endcase
end

endmodule