module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding
localparam [2:0]
    S_A = 3'd0, // Reset state
    S_B = 3'd1, // Output f=1 for one cycle
    S_C0 = 3'd2, // Monitor x for first '1' in sequence
    S_C1 = 3'd3, // Monitor x for '0' after first '1'
    S_C2 = 3'd4, // Monitor x for second '1' after '0'
    S_D  = 3'd5, // g=1, monitor y for up to 2 cycles
    S_E  = 3'd6, // g=1 permanently (y=1 detected)
    S_F  = 3'd7; // g=0 permanently (y=1 not detected within 2 cycles)

// State register
reg [2:0] state, next_state;

// Counter for monitoring y for two cycles in S_D
reg [1:0] y_counter;

// Sequential state transition and output update
always @(posedge clk) begin
    if (!resetn) begin
        // Synchronous active-low reset: go to state A
        state <= S_A;
        f <= 1'b0;
        g <= 1'b0;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;
        
        // Default outputs hold unless changed below
        case(next_state)
            S_A: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            S_B: begin
                f <= 1'b1; // f=1 for one cycle
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            S_C0: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            S_C1: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            S_C2: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            S_D: begin
                f <= 1'b0;
                g <= 1'b1;
                // y_counter update handled below
            end
            S_E: begin
                f <= 1'b0;
                g <= 1'b1;
                y_counter <= y_counter; // hold
            end
            S_F: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= y_counter; // hold
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
        endcase

        // Update y_counter only in S_D, else reset it
        if (next_state == S_D) begin
            if (state == S_D) begin
                // increment counter on each clock
                y_counter <= y_counter + 1'b1;
            end else begin
                // entering S_D, reset counter
                y_counter <= 2'd0;
            end
        end else begin
            y_counter <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    // Default next state
    next_state = state;

    case(state)
        S_A: begin
            if (resetn) begin
                // reset de-asserted: go to S_B to assert f=1 for one cycle
                next_state = S_B;
            end else begin
                next_state = S_A;
            end
        end

        S_B: begin
            // After one cycle of f=1, go to monitor x sequence
            next_state = S_C0;
        end

        // FSM to detect x=1,0,1 in three successive clock cycles
        S_C0: begin
            // Looking for first 1 in x
            if (x == 1'b1)
                next_state = S_C1;
            else
                next_state = S_C0; // stay until first 1 detected
        end

        S_C1: begin
            // After seeing first '1', expect '0' next
            if (x == 1'b0)
                next_state = S_C2;
            else if (x == 1'b1)
                next_state = S_C1; // still first '1', maybe repeated, wait for 0
            else
                next_state = S_C0; // fallback, start over (should not happen for 1-bit)
        end

        S_C2: begin
            // After seeing '1','0' expect '1' next
            if (x == 1'b1) 
                next_state = S_D; // sequence detected, set g=1 next clock
            else if (x == 1'b0)
                next_state = S_C0; // sequence broken, restart looking
            else
                next_state = S_C0; // fallback
        end

        S_D: begin
            // g=1, monitor y for up to 2 clock cycles
            // If y=1 detected, go to S_E
            // Else if 2 cycles elapsed (counter >=2), go to S_F
            if (y == 1'b1)
                next_state = S_E;
            else if (y_counter >= 2'd1) // after 2 clock cycles (counter increments from 0)
                next_state = S_F;
            else
                next_state = S_D;
        end

        S_E: begin
            // g=1 permanently
            next_state = S_E;
        end

        S_F: begin
            // g=0 permanently
            next_state = S_F;
        end

        default: next_state = S_A;
    endcase
end

endmodule