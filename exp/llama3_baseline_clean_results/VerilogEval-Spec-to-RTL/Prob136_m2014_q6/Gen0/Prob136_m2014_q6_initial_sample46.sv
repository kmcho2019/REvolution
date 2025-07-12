module TopModule(
  input  clk,
  input  reset,
  input  w,
  output z
);

// Define states
localparam [2:0] A = 3'b000;
localparam [2:0] B = 3'b001;
localparam [2:0] C = 3'b002;
localparam [2:0] D = 3'b003;
localparam [2:0] E = 3'b004;
localparam [2:0] F = 3'b005;

// Current state
reg [2:0] current_state;
reg [2:0] next_state;

// Determine next state
always @(*)
begin
  case(current_state)
    A: next_state = (w) ? A : B;
    B: next_state = (w) ? D : C;
    C: next_state = (w) ? D : E;
    D: next_state = (w) ? A : F;
    E: next_state = (w) ? D : E;
    F: next_state = (w) ? D : C;
    default: next_state = A;
  endcase
end

// Update current state
always @(posedge clk or posedge reset)
begin
  if(reset)
    current_state <= A;
  else
    current_state <= next_state;
end

// Generate output z
assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;

endmodule