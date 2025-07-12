module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Define states for the state machine
typedef enum logic [1:0] {
    S_IDLE,
    S_BIT0,
    S_BIT1,
    S_BIT2
} state_t;

state_t current_state, next_state;  // Current and next states

// Sequential logic for state machine
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        current_state <= S_IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and outputs
always_comb begin
    case (current_state)
        S_IDLE: begin
            // Load input data and start conversion
            next_state = S_BIT0;
            valid_out = 1'b1;
            dout = d[3];
        end
        S_BIT0: begin
            next_state = S_BIT1;
            valid_out = 1'b0;
            dout = d[2];
        end
        S_BIT1: begin
            next_state = S_BIT2;
            valid_out = 1'b0;
            dout = d[1];
        end
        S_BIT2: begin
            next_state = S_IDLE;
            valid_out = 1'b0;
            dout = d[0];
        end
    endcase
end

endmodule