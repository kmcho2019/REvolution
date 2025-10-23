// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// State machine states
enum logic [1:0] {IDLE, LOAD, SHIFT, RESET} state, next_state;

// 4-bit shift register
reg [3:0] q_reg;

// State machine logic
always_comb begin
    case (state)
        IDLE: begin
            if (load) begin
                next_state = LOAD;
            end else if (ena) begin
                next_state = SHIFT;
            end else begin
                next_state = IDLE;
            end
        end
        LOAD: begin
            next_state = IDLE;
        end
        SHIFT: begin
            next_state = IDLE;
        end
        RESET: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for state machine and register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        state <= IDLE;
        q_reg <= 4'b0;
    end else begin
        // Update state machine and register on positive edge of clock
        state <= next_state;
        case (state)
            LOAD: begin
                // Load data
                q_reg <= data;
            end
            SHIFT: begin
                // Shift right
                q_reg <= {1'b0, q_reg[3:1]};
            end
            default: begin
                // No operation, maintain current state
                q_reg <= q_reg;
            end
        endcase
    end
end

// Assign output
assign q = q_reg;

endmodule