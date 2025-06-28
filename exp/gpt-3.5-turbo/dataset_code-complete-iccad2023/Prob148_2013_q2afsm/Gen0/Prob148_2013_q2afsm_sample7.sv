module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// Define states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define state register
reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;
  end else begin
    state <= next_state;
  end
end

// Output logic
always @(*) begin
  g = 3'b000; // Initialize g values
  
  case(state)
    A: begin
      if (r[1]) begin
        g = {1'b1, 2'b00}; // Grant access to device 1
        next_state = B;
      end else if (r[2]) begin
        g = {1'b0, 1'b1, 1'b0}; // Grant access to device 2
        next_state = C;
      end else if (r[3]) begin
        g = {1'b0, 2'b01}; // Grant access to device 3
        next_state = D;
      end else begin
        next_state = A;
      end
    end
    
    B: begin
      if (r[1]) begin
        g = {1'b1, 2'b00}; // Grant access to device 1
        next_state = B;
      end else begin
        g = {1'b0, 1'b0, 1'b0}; // No grants
        next_state = A;
      end
    end
    
    C: begin
      if (r[2]) begin
        g = {1'b0, 1'b1, 1'b0}; // Grant access to device 2
        next_state = C;
      end else begin
        g = {1'b0, 0, 1'b0}; // No grants
        next_state = A;
      end
    end
    
    D: begin
      if (r[3]) begin
        g = {1'b0, 2'b01}; // Grant access to device 3
        next_state = D;
      end else begin
        g = {1'b0, 0, 1'b0}; // No grants
        next_state = A;
      end
    end
  endcase
end

endmodule