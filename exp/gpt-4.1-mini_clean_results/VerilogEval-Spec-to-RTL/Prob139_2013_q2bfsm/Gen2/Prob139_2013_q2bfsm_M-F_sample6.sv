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
reg [1:0] y_counter; // counts 0 and 1 for the two cycles monitoring y

// Sequential logic for state and y_counter
always @(posedge clk) begin
    if (!resetn) begin
        state     <= STATE_A;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;
        // y_counter logic
        // On entering STATE_D, reset counter to 0
        // While in STATE_D, increment counter each cycle
        if (next_state == STATE_D && state != STATE_D) begin
            y_counter <= 2'd0;
        end else if (state == STATE_D && next_state == STATE_D) begin
            y_counter <= y_counter + 1'b1;
        end else begin
            y_counter <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        // Reset state, wait for resetn to go high
        STATE_A: begin
            if (resetn)
                next_state = STATE_B;
            else
                next_state = STATE_A;
        end

        // One cycle pulse of f
        STATE_B: begin
            next_state = STATE_C0;
        end

        // Sequence detection states: looking for x sequence 1,0,1

        // Wait for x=1 to start sequence
        STATE_C0: begin
            if (x == 1'b1)
                next_state = STATE_C1;
            else // x==0
                next_state = STATE_C0;
        end

        // Waiting for x=0 after seeing x=1
        STATE_C1: begin
            if (x == 1'b0)
                next_state = STATE_C2;
            else // x==1
                next_state = STATE_C1; // stay here waiting for 0
        end

        // Waiting for x=1 to complete sequence 1,0,1
        STATE_C2: begin
            if (x == 1'b1)
                next_state = STATE_D; // sequence detected
            else // x==0
                next_state = STATE_C0; // restart sequence detection
        end

        // State D: g=1, monitor y input for up to two cycles after entering D
        STATE_D: begin
            if (y == 1'b1)
                next_state = STATE_E; // success: permanent g=1
            else if (y_counter == 2'd1)
                next_state = STATE_F; // fail: permanent g=0
            else
                next_state = STATE_D; // keep monitoring
        end

        // Permanent success state with g=1
        STATE_E: begin
            next_state = STATE_E; // stay until reset
        end

        // Permanent failure state with g=0
        STATE_F: begin
            next_state = STATE_F; // stay until reset
        end

        default: begin
            next_state = STATE_A;
        end
    endcase
end

// Output logic
always @(*) begin
    // Defaults
    f = 1'b0;
    g = 1'b0;

    case (state)
        STATE_B: f = 1'b1;          // f=1 one cycle after reset release
        STATE_D,
        STATE_E: g = 1'b1;          // g=1 during monitoring and permanent success
        // g=0 otherwise (including STATE_F)
        default: begin
            f = 1'b0;
            g = 1'b0;
        end
    endcase
end

endmodule