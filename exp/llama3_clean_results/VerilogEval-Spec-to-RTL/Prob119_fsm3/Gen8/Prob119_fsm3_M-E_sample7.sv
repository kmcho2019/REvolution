module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define the counter
reg [1:0] counter;
reg [1:0] next_counter;

// Combinational logic for next state
always @(*) begin
  case (counter)
    2'd0: next_counter = in ? 2'd1 : 2'd0; // State A
    2'd1: next_counter = in ? 2'd1 : 2'd2; // State B
    2'd2: next_counter = in ? 2'd3 : 2'd0; // State C
    2'd3: next_counter = in ? 2'd1 : 2'd2; // State D
    default: next_counter = 2'd0; // Default state
  endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
  if (areset) begin
    counter <= 2'd0;
  end else begin
    counter <= next_counter;
  end
end

// Output logic
assign out = (counter == 2'd3);

endmodule