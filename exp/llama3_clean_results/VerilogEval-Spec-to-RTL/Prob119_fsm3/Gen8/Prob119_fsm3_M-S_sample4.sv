module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define states
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

// Define the state register
reg [1:0] state;

// Combinational logic for next state
always @(*) begin
  case (state)
    A: state <= in ? B : A;
    B: state <= in ? B : C;
    C: state <= in ? D : A;
    D: state <= in ? B : C;
    default: state <= A; // Default state
  endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= A;
  end else begin
    // Directly assign next state based on combinational logic output
    // Not needed, combinational logic already assigns to state
  end
end

// Output logic
assign out = (state == D);

endmodule