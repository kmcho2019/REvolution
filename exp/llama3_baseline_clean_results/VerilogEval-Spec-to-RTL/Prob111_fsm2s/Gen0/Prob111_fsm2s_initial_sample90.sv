module TopModule (
  input  clk,
  input  reset,
  input  j,
  input  k,
  output out
);

reg [1:0] current_state, next_state;

// Define states
localparam OFF = 2'b00;
localparam ON  = 2'b01;

// Output logic
assign out = (current_state == ON) ? 1'b1 : 1'b0;

// Sequential logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    current_state <= OFF;
  end else begin
    current_state <= next_state;
  end
end

// Combinational logic
always @(*) begin
  case (current_state)
    OFF: begin
      if (j) begin
        next_state = ON;
      end else begin
        next_state = OFF;
      end
    end
    ON: begin
      if (k) begin
        next_state = OFF;
      end else begin
        next_state = ON;
      end
    end
    default: next_state = OFF;
  endcase
end

endmodule