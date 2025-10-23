module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding (3 bits)
localparam [2:0]
    STATE_A  = 3'd0, // Reset state
    STATE_B  = 3'd1, // f=1 one cycle after reset release
    STATE_C0 = 3'd2, // waiting for x=1 (start of sequence)
    STATE_C1 = 3'd3, // waiting for x=0 after x=1
    STATE_C2 = 3'd4, // waiting for x=1 after x=1,0
    STATE_D  = 3'd5, // g=1 monitoring y input (up to 2 cycles)
    STATE_E  = 3'd6, // g=1 permanent success
    STATE_F  = 3'd7; // g=0 permanent fail

reg [2:0] state, next_state;
reg [1:0] y_counter; // counts monitoring cycles in STATE_D: 0 or 1

// Sequential logic: state, y_counter, outputs f,g
always @(posedge clk) begin
    if (!resetn) begin
        state     <= STATE_A;
        y_counter <= 2'd0;
        f         <= 1'b0;
        g         <= 1'b0;
    end else begin
        state <= next_state;

        // Manage y_counter in STATE_D
        if (state == STATE_D) begin
            if (next_state == STATE_D) begin
                // Continue counting
                y_counter <= y_counter + 1'b1;
            end else begin
                // Leaving D: reset counter
                y_counter <= 2'd0;
            end
        end else if (next_state == STATE_D) begin
            // Entering D: initialize counter
            y_counter <= 2'd0;
        end else begin
            // Outside D: reset counter
            y_counter <= 2'd0;
        end

        // Update outputs synchronously according to the **next state** to match timing (next cycle outputs)
        // This ensures outputs align with FSM state output requirements.
        case (next_state)
            STATE_B: begin
                f <= 1'b1; // f pulse one cycle after reset release
                g <= 1'b0;
            end
            STATE_D, STATE_E: begin
                f <= 1'b0;
                g <= 1'b1;
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
            end
        endcase
    end
end

// Next state combinational logic
always @(*) begin
    next_state = state; // default hold

    case(state)
        STATE_A: begin
            if (resetn)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        end

        STATE_B: begin
            next_state = STATE_C0; // after one-cycle pulse f, go to sequence detection
        end

        // Sequence detection states
        // Wait for x=1 to start sequence
        STATE_C0: begin
            if (x == 1'b1)
                next_state = STATE_C1;
            else // x == 0
                next_state = STATE_C0;
        end

        // After seeing x=1, wait for x=0
        STATE_C1: begin
            if (x == 1'b0)
                next_state = STATE_C2;
            else // x == 1
                next_state = STATE_C1; 
                // stay here as repeated 1's could be start of new sequence
        end

        // After sequence 1,0 wait for x=1 to complete
        STATE_C2: begin
            if (x == 1'b1)
                next_state = STATE_D; // sequence 1,0,1 detected
            else // x == 0
                // Here, the last input was 0, so sequence can partially restart from C1 state
                next_state = STATE_C1;
        end

        // STATE_D: monitor y for at most two cycles
        STATE_D: begin
            if (y == 1'b1)
                next_state = STATE_E; // permanent g=1 success
            else if (y_counter == 2'd1)
                next_state = STATE_F; // failed after two cycles with no y=1
            else
                next_state = STATE_D; // keep monitoring
        end

        STATE_E: begin
            // Permanent success, stay until reset
            next_state = STATE_E;
        end

        STATE_F: begin
            // Permanent failure, stay until reset
            next_state = STATE_F;
        end

        default: begin
            next_state = STATE_A;
        end
    endcase
end

endmodule