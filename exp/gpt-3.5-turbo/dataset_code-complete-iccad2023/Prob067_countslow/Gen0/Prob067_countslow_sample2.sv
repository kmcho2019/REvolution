module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

  // Enumerated type for the states
  typedef enum logic [2:0] {
    IDLE,
    COUNT
  } state_t;
  
  // Define state register
  reg [2:0] state, next_state;
  
  // Define counter register
  reg [3:0] count;
  
  // Sequential logic for state machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      count <= 4'd0;
    end else begin
      state <= next_state;
      count <= slowena ? (count == 4'd9 ? 4'd0 : count + 1) : count; 
    end
  end
  
  // Combinational logic for state transitions
  always @* begin
    case (state)
      IDLE: begin
        next_state = slowena ? COUNT : IDLE;
      end
      COUNT: begin
        next_state = COUNT;
      end
      default: next_state = IDLE;
    endcase
  end
  
  // Output register
  always @* begin
    q = count;
  end

endmodule