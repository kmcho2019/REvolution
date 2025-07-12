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
    S_A  = 3'd0, // Reset state
    S_B  = 3'd1, // Output f=1 for one cycle
    S_C0 = 3'd2, // Waiting for x=1 (start sequence)
    S_C1 = 3'd3, // Waiting for x=0 (second step)
    S_C2 = 3'd4, // Waiting for x=1 (third step)
    S_D  = 3'd5, // g=1, monitor y for 2 cycles
    S_E  = 3'd6, // g=1 permanently
    S_F  = 3'd7; // g=0 permanently

reg [2:0] state, next_state;
reg [1:0] y_counter;  // counts 0 and 1 for two cycles monitoring y

// Sequential block: state transitions, output and counter update
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_A;
        f <= 1'b0;
        g <= 1'b0;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;

        // Outputs assigned based on current state (not next_state!)
        case(state)
            S_A: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
            S_B: begin
                f <= 1'b1;  // f=1 for one clock cycle after reset released
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
                // increment y_counter every clock in S_D
                if (state == S_D)
                    y_counter <= y_counter + 1'b1;
                else
                    y_counter <= 2'd0; // reset counter entering S_D
            end
            S_E: begin
                f <= 1'b0;
                g <= 1'b1;
                // Hold y_counter (not used further)
                y_counter <= y_counter;
            end
            S_F: begin
                f <= 1'b0;
                g <= 1'b0;
                // Hold y_counter (not used further)
                y_counter <= y_counter;
            end
            default: begin
                f <= 1'b0;
                g <= 1'b0;
                y_counter <= 2'd0;
            end
        endcase
    end
end

// Next state combinational logic
always @(*) begin
    next_state = state; // default hold

    case(state)
        S_A: begin
            if (resetn)
                next_state = S_B; // reset released: next cycle f=1
            else
                next_state = S_A;
        end

        S_B: begin
            // After outputting f=1 one cycle, move to monitor x sequence
            next_state = S_C0;
        end

        S_C0: begin
            // Wait for first '1' in x
            if (x == 1'b1)
                next_state = S_C1;
            else
                next_state = S_C0; // stay until first '1'
        end

        S_C1: begin
            // Expect '0' next in x
            if (x == 1'b0)
                next_state = S_C2;
            else if (x == 1'b1)
                next_state = S_C1; // still waiting for '0'
            else
                next_state = S_C0; // fallback, restart
        end

        S_C2: begin
            // Expect '1' next in x to complete sequence
            if (x == 1'b1)
                next_state = S_D; // sequence detected
            else
                next_state = S_C0; // restart if broken
        end

        S_D: begin
            // Monitor y for up to 2 cycles (counter counts 0 and 1)
            if (y == 1'b1) begin
                next_state = S_E; // y=1 detected, keep g=1 permanently
            end else if (y_counter == 2'd1) begin
                // waited two cycles (counter=0 then 1)
                next_state = S_F; // y=1 not detected within 2 cycles
            end else begin
                next_state = S_D; // keep monitoring
            end
        end

        S_E: begin
            // g=1 permanently until reset
            next_state = S_E;
        end

        S_F: begin
            // g=0 permanently until reset
            next_state = S_F;
        end

        default: next_state = S_A;
    endcase
end

endmodule