// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations using an FSM
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]   q         // Output data
);

// Enum for FSM states
enum logic [1:0] {
    IDLE,
    LOAD_STATE,
    SHIFT_STATE
} state, next_state;

// 4-bit shift register
reg [3:0] q_reg;

// FSM logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        state <= IDLE;
        q_reg <= 4'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (load) begin
                    // Transition to load state
                    next_state <= LOAD_STATE;
                end else if (ena) begin
                    // Transition to shift state
                    next_state <= SHIFT_STATE;
                end else begin
                    // Stay in idle state
                    next_state <= IDLE;
                end
            end
            LOAD_STATE: begin
                // Load data into register
                q_reg <= data;
                // Transition back to idle state
                next_state <= IDLE;
            end
            SHIFT_STATE: begin
                // Shift register right
                q_reg <= {1'b0, q_reg[3:1]};
                // Transition back to idle state
                next_state <= IDLE;
            end
            default: begin
                // Default to idle state
                next_state <= IDLE;
            end
        endcase
    end
end

// Assign output
assign q = q_reg;

endmodule