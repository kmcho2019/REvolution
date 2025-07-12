module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

typedef enum logic [1:0] {
    RESET,         // Initial state
    SEQ_DETECT1,   // Detect first '1' in sequence
    SEQ_DETECT2,   // Detect '0' in sequence
    SEQ_DETECT3,   // Detect second '1' in sequence
    WAIT_Y         // Wait for 'y' after sequence detection
} state_t;

state_t state, nextState;

reg [1:0] seq_count; // Counter for sequence detection
reg [1:0] wait_count; // Counter for waiting for 'y'

always @ (posedge clk) begin
    if (!resetn) begin
        // Reset all signals and states
        state <= RESET;
        seq_count <= 0;
        wait_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            RESET: begin
                nextState = RESET;
                if (x) begin
                    nextState = SEQ_DETECT1;
                    seq_count <= 1;
                end
            end
            SEQ_DETECT1: begin
                nextState = SEQ_DETECT1;
                if (!x) begin
                    nextState = SEQ_DETECT2;
                end else if (seq_count < 2) begin
                    seq_count <= seq_count + 1;
                end
            end
            SEQ_DETECT2: begin
                nextState = SEQ_DETECT2;
                if (x) begin
                    nextState = SEQ_DETECT3;
                    seq_count <= 1;
                    f <= 1; // Set f for this cycle
                end
            end
            SEQ_DETECT3: begin
                nextState = WAIT_Y;
                wait_count <= 1;
            end
            WAIT_Y: begin
                nextState = WAIT_Y;
                if (y) begin
                    g <= 1; // Set g permanently if y is seen
                    nextState = RESET;
                end else if (wait_count < 2) begin
                    wait_count <= wait_count + 1;
                end else begin
                    g <= 0; // Set g to 0 if y not seen within 2 cycles
                    nextState = RESET;
                end
            end
        endcase
        state <= nextState;
        
        // Reset f for next cycle if it was set
        if (f) f <= 0;
    end
end

endmodule