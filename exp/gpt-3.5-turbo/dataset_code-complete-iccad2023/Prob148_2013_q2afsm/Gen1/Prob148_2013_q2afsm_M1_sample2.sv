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
      end else if(r[2]) begin
        next_state = C;
      end else if(r[3]) begin
        next_state = D;
      end
    end
    B: begin
      if(!r[1]) begin
        next_state = A;
      end
    end
    C: begin
      if(!r[2]) begin
        next_state = A;
      end
    end
    D: begin
      if(r[1]) begin
        next_state = D;
        g[1] = 1;
      end else if(r[2]) begin
        next_state = D;
        g[2] = 1;
      end else if(r[3]) begin
        next_state = D;
        g[3] = 1;
      end
    end
  endcase
end

// Grant outputs based on the current state
always @(*) begin
  g = {3{1'b0}}; // Initialize grants to 0
  case(state)
    B: begin
      if(r[1]) begin
        g[1] = 1;
      end
    end
    C: begin
      if(r[2]) begin
        g[2] = 1;
      end
    end
  endcase
end

endmodule