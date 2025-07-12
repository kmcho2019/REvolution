module TopModule (
  input  clk,
  input  areset,
  input  j,
  input  k,
  output out
);

// Define the states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Declare the state variable
reg current_state;

// Initialize the output
assign out = current_state;

// Handle state transitions
always @(posedge clk or posedge areset) begin
  if (areset) begin
    current_state <= OFF;
  end else begin
    case (current_state)
      OFF: begin
        if (j) begin
          current_state <= ON;
        end else begin
          current_state <= OFF;
        end
      end
      ON: begin
        if (k) begin
          current_state <= OFF;
        end else begin
          current_state <= ON;
        end
      end
      default: current_state <= OFF;
    endcase
  end
end

endmodule