module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// State encoding
localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

reg [1:0] state, next_state;

// State flip-flops with synchronous active-low reset
always @(posedge clk) begin
  if (~resetn)
    state <= A;
  else
    state <= next_state;
end

// Next state logic
always @(*) begin
  case (state)
    A: begin
      // Priority: device1 > device2 > device3
      if (r[1])
        next_state = B;
      else if (r[2])
        next_state = C;
      else if (r[3])
        next_state = D;
      else
        next_state = A;
    end

    B: begin
      if (r[1])
        next_state = B;
      else
        next_state = A;
    end

    C: begin
      if (r[2])
        next_state = C;
      else
        next_state = A;
    end

    D: begin
      if (r[3])
        next_state = D;
      else
        next_state = A;
    end

    default: next_state = A;
  endcase
end

// Output logic (grant signals)
always @(*) begin
  case (state)
    B: g = 3'b100; // grant device 1
    C: g = 3'b010; // grant device 2
    D: g = 3'b001; // grant device 3
    default: g = 3'b000;
  endcase
end

endmodule