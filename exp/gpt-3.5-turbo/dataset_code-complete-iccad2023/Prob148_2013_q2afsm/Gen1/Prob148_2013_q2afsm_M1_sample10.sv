module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// Define state codes
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define state register and next state
reg [1:0] state, next_state;

// State flip-flop
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
    g = {3{1'b0}}; // Initialize grants to 0
  end else begin
    state <= next_state;
  end
end

// State table logic
always @(*) begin
  next_state = state;

  case(state)
    A: begin
      if(r[1]) begin
        next_state = B;
        g = {1, 0, 0};
      end else if(r[2]) begin
        next_state = C;
        g = {0, 1, 0};
      end else if(r[3]) begin
        next_state = A;
        g = {0, 0, 1};
      end
    end
    B: begin
      if(r[1]) begin
        next_state = B;
      end else begin
        next_state = A;
      end
    end
    C: begin
      if(r[2]) begin
        next_state = C;
      end else begin
        next_state = A;
      end
    end
    D: begin
      if(r[1]) begin
        next_state = D;
        g = {1, 0, 0};
      end else if(r[2]) begin
        next_state = D;
        g = {0, 1, 0};
      else if(r[3]) begin
        next_state = D;
        g = {0, 0, 1};
      else begin
        next_state = A;
      end
    end
  endcase
end

endmodule