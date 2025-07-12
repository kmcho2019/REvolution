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
    S_C0 = 3'd2, // Waiting for first '1' in x sequence
    S_C1 = 3'd3, // After first '1', waiting for '0'
    S_C2 = 3'd4, // After '1','0', waiting for second '1'
    S_D  = 3'd5, // g=1, monitor y for up to two cycles
    S_E  = 3'd6, // g=1 permanently (y=1 detected)
    S_F  = 3'd7; // g=0 permanently (y=1 not detected within 2 cycles)

// State register
reg [2:0] state, next_state;

// 2-bit counter for monitoring y input duration in S_D
reg [1:0] y_counter, next_y_counter;

// Sequential logic for state and counter
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_A;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;
        y_counter <= next_y_counter;
    end
end

// Combinational next state and y_counter logic
always @(*) begin
    next_state = state;         // default hold
    next_y_counter = y_counter; // default hold

    case(state)
        S_A: begin
            if (resetn)
                next_state = S_B; // reset deasserted, go to f=1 pulse state
            else
                next_state = S_A;
            next_y_counter = 2'd0;
        end

        S_B: begin
            // After one cycle f=1, go to monitor x sequence
            next_state = S_C0;
            next_y_counter = 2'd0;
        end

        // FSM for detecting x sequence 1,0,1
        S_C0: begin
            if (x == 1'b1)
                next_state = S_C1;
            else
                next_state = S_C0; // wait for first '1'
            next_y_counter = 2'd0;
        end

        S_C1: begin
            if (x == 1'b0)
                next_state = S_C2;
            else if (x == 1'b1)
                next_state = S_C1; // stay waiting for '0'
            else
                next_state = S_C0; // fallback (not needed, but safe)
            next_y_counter = 2'd0;
        end

        S_C2: begin
            if (x == 1'b1)
                next_state = S_D; // sequence 1,0,1 detected
            else
                next_state = S_C0; // sequence broken, restart
            next_y_counter = 2'd0;
        end

        S_D: begin
            // Monitor y for up to 2 cycles
            // Increment y_counter on each clock while in S_D
            if (y == 1'b1) begin
                next_state = S_E; // y=1 detected, stay g=1 permanently
                next_y_counter = y_counter; // counter hold (not necessary anymore)
            end else if (y_counter == 2'd1) begin
                // After 2 cycles (counter starts at 0), y still 0 => g=0 permanently
                next_state = S_F;
                next_y_counter = y_counter; // hold counter
            end else begin
                // Stay in S_D and increment y_counter
                next_state = S_D;
                next_y_counter = y_counter + 1'b1;
            end
        end

        S_E: begin
            // Remain here with g=1 permanently
            next_state = S_E;
            next_y_counter = y_counter;
        end

        S_F: begin
            // Remain here with g=0 permanently
            next_state = S_F;
            next_y_counter = y_counter;
        end

        default: begin
            next_state = S_A;
            next_y_counter = 2'd0;
        end
    endcase
end

// Outputs depend purely on current state (Moore machine)
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        case(state)
            S_A: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            S_B: begin
                f <= 1'b1; // f=1 for exactly one cycle
                g <= 1'b0;
            end
            S_C0, S_C1, S_C2: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            S_D: begin
                f <= 1'b0;
                g <= 1'b1;
            end
            S_E: begin
                f <= 1'b0;
                g <= 1'b1;
            end
            S_F: begin
                f <= 1'b0;
                g <= 1'b0;
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
            end
        endcase
    end
end

endmodule