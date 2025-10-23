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
    STATE_B  = 3'd1, // f=1 for one cycle after reset release
    STATE_C0 = 3'd2, // Sequence detection: waiting for first x=1
    STATE_C1 = 3'd3, // Sequence detected x=1, waiting for x=0
    STATE_C2 = 3'd4, // Sequence detected x=1,0 waiting for x=1
    STATE_D  = 3'd5, // g=1 monitoring y input for up to two cycles
    STATE_E  = 3'd6, // g=1 permanent success
    STATE_F  = 3'd7; // g=0 permanent failure

reg [2:0] state, next_state;
reg [1:0] y_counter; // counts 0 and 1 cycles while monitoring y

// Sequential logic: state and y_counter
always @(posedge clk) begin
    if (!resetn) begin
        state     <= STATE_A;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;

        // y_counter logic:
        // Reset to 0 on entering STATE_D, increment by 1 while staying in STATE_D
        if (state != STATE_D && next_state == STATE_D) begin
            y_counter <= 2'd0;
        end else if (state == STATE_D && next_state == STATE_D) begin
            y_counter <= y_counter + 1'b1;
        end else begin
            y_counter <= 2'd0;
        end
    end
end

// Next state logic (Moore style except sequence detector which acts like Mealy on x)
always @(*) begin
    next_state = state; // default hold

    case (state)
        STATE_A: begin
            if (resetn)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        end

        STATE_B: begin
            // f=1 for one cycle then move to sequence detection start
            next_state = STATE_C0;
        end

        // Sequence detection using Moore states, but Mealy transitions on x:
        // We try to recognize the sequence 1,0,1 on consecutive clock cycles.

        STATE_C0: begin
            // Waiting for x=1 to start sequence
            if (x == 1'b1)
                next_state = STATE_C1;
            else
                next_state = STATE_C0;
        end

        STATE_C1: begin
            // After detecting x=1, expect x=0 next
            if (x == 1'b0)
                next_state = STATE_C2;
            else if (x == 1'b1)
                // Still x=1, stay here to allow sequence to start anew
                next_state = STATE_C1;
            else
                next_state = STATE_C0; // Defensive fallback to restart
        end

        STATE_C2: begin
            // After detecting x=1,0, expect x=1 to complete sequence
            if (x == 1'b1)
                next_state = STATE_D; // Sequence complete, move to monitor y
            else if (x == 1'b0)
                // Sequence broke, restart detection from x=0
                next_state = STATE_C0;
            else
                next_state = STATE_C0;
        end

        STATE_D: begin
            // Monitor y for up to 2 cycles (y_counter 0 and 1)
            if (y == 1'b1)
                next_state = STATE_E; // Success: permanent g=1
            else if (y_counter == 2'd1)
                next_state = STATE_F; // Failure after 2 cycles without y=1
            else
                next_state = STATE_D; // Keep monitoring
        end

        STATE_E: begin
            // Permanent success state, hold until reset
            next_state = STATE_E;
        end

        STATE_F: begin
            // Permanent failure state, hold until reset
            next_state = STATE_F;
        end

        default: begin
            next_state = STATE_A;
        end
    endcase
end

// Output logic: purely combinational based on current state
always @(*) begin
    // Default outputs
    f = 1'b0;
    g = 1'b0;

    case (state)
        STATE_B: f = 1'b1;          // f=1 for one cycle after reset release
        STATE_D,
        STATE_E: g = 1'b1;          // g=1 during monitoring and permanent success
        default: begin
            f = 1'b0;
            g = 1'b0;               // g=0 otherwise
        end
    endcase
end

endmodule