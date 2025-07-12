// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// Define the states of the finite state machine
typedef enum logic [1:0] {
    RESET_STATE,
    LOAD_STATE,
    SHIFT_STATE,
    IDLE_STATE
} state_type;

// Current state and next state of the FSM
reg state_type current_state, next_state;

// 4-bit shift register
reg [3:0] q_reg;

// Asynchronous reset
always @(posedge areset) begin
    current_state <= RESET_STATE;
    q_reg <= 4'b0;
end

// Synchronous operations
always @(posedge clk) begin
    current_state <= next_state;
    case (current_state)
        LOAD_STATE: begin
            q_reg <= data;
        end
        SHIFT_STATE: begin
            q_reg <= {1'b0, q_reg[3:1]};
        end
        default: begin
            // No operation
        end
    endcase
end

// Next state logic
always @(*) begin
    case (current_state)
        RESET_STATE: begin
            if (load) begin
                next_state = LOAD_STATE;
            end else if (ena) begin
                next_state = SHIFT_STATE;
            end else begin
                next_state = IDLE_STATE;
            end
        end
        LOAD_STATE: begin
            next_state = IDLE_STATE;
        end
        SHIFT_STATE: begin
            next_state = IDLE_STATE;
        end
        IDLE_STATE: begin
            if (areset) begin
                next_state = RESET_STATE;
            end else if (load) begin
                next_state = LOAD_STATE;
            end else if (ena) begin
                next_state = SHIFT_STATE;
            end else begin
                next_state = IDLE_STATE;
            end
        end
        default: begin
            next_state = IDLE_STATE;
        end
    endcase
end

// Assign output
assign q = q_reg;

endmodule