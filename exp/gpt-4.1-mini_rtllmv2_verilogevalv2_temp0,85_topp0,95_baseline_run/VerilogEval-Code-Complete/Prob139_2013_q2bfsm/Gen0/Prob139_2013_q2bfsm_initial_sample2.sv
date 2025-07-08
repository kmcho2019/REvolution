module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum reg [3:0] {
    A = 4'd0,          // initial state, reset asserted
    F_ON = 4'd1,       // output f=1 for 1 cycle after reset deasserted
    WAIT_X1 = 4'd2,    // waiting for first x=1
    WAIT_X0 = 4'd3,    // waiting for x=0 after x=1 detected
    WAIT_X2 = 4'd4,    // waiting for x=1 after 1,0 detected (sequence complete here)
    G_ON_MONITOR_Y0 = 4'd5, // g=1, first cycle monitoring y=1
    G_ON_MONITOR_Y1 = 4'd6, // g=1, second cycle monitoring y=1
    G_ON_PERMANENT = 4'd7,  // g=1 permanently after y=1 detected within 2 cycles
    G_OFF_PERMANENT = 4'd8  // g=0 permanently if y not detected within 2 cycles
  } state_t;

  state_t state, next_state;

  // State register
  always @(posedge clk) begin
    if (~resetn)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic and output logic
  always @(*) begin
    // Default outputs
    f = 1'b0;
    g = 1'b0;
    next_state = state;

    case(state)
      A: begin
        // stay in A while resetn low
        // When resetn goes high, move to F_ON next clock cycle
        if (resetn)
          next_state = F_ON;
      end

      F_ON: begin
        f = 1'b1;    // output f=1 for one cycle
        next_state = WAIT_X1;
      end

      WAIT_X1: begin
        // Wait for x=1 to start sequence detection
        // If x=1, move to WAIT_X0, else stay
        if (x)
          next_state = WAIT_X0;
      end

      WAIT_X0: begin
        // Wait for x=0 after first x=1
        if (~x)
          next_state = WAIT_X2;
        else if (x==1) 
          next_state = WAIT_X0; // stay if x=1, waiting for 0
        else
          next_state = WAIT_X1; // if x neither 1 nor 0? only 1 bit, just wait for 0
      end

      WAIT_X2: begin
        // Wait for x=1 again to complete sequence 1,0,1
        if (x)
          next_state = G_ON_MONITOR_Y0;
        else
          next_state = WAIT_X1; // reset sequence search if x!=1
      end

      G_ON_MONITOR_Y0: begin
        g = 1'b1;
        // Start monitoring y input for 2 cycles
        // if y=1, go permanent g=1
        if (y)
          next_state = G_ON_PERMANENT;
        else
          next_state = G_ON_MONITOR_Y1;
      end

      G_ON_MONITOR_Y1: begin
        g = 1'b1;
        if (y)
          next_state = G_ON_PERMANENT;
        else
          next_state = G_OFF_PERMANENT;
      end

      G_ON_PERMANENT: begin
        g = 1'b1;
        // stay here until reset
      end

      G_OFF_PERMANENT: begin
        g = 1'b0;
        // stay here until reset
      end

      default: begin
        next_state = A;
      end
    endcase
  end

endmodule