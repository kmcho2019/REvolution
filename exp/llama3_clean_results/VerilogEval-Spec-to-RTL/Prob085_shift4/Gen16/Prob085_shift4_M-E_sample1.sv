// TopModule: 4-bit shift register with asynchronous reset, synchronous load, and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// Define states for the FSM
enum logic [1:0] {
    IDLE,
    LOAD,
    SHIFT,
    RESET
} state, next_state;

// 4-bit shift register
reg [3:0] q_reg;

// Asynchronous reset, synchronous load and shift operations
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        state <= RESET;
        q_reg <= 4'b0;
    end else begin
        // Update the state and register based on the current state and inputs
        case (state)
            IDLE: begin
                if (load) begin
                    state <= LOAD;
                end else if (ena) begin
                    state <= SHIFT;
                end
            end
            LOAD: begin
                q_reg <= data;
                state <= IDLE;
            end
            SHIFT: begin
                q_reg <= {1'b0, q_reg[3:1]};
                state <= IDLE;
            end
            RESET: begin
                state <= IDLE;
            end
        endcase
    end
end

// Assign output
assign q = q_reg;

endmodule