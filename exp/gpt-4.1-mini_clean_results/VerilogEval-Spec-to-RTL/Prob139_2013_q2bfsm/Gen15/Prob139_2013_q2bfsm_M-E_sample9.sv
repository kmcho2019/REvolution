module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum logic [3:0] {
        STATE_A  = 4'd0,  // wait resetn=1
        STATE_B  = 4'd1,  // f=1 pulse (one cycle)
        STATE_C0 = 4'd2,  // waiting for x=1
        STATE_C1 = 4'd3,  // waiting for x=0
        STATE_C2 = 4'd4,  // waiting for x=1
        STATE_D  = 4'd5,  // g=1 pulse (one cycle)
        STATE_E0 = 4'd6,  // first cycle monitoring y with g=1
        STATE_E1 = 4'd7,  // second cycle monitoring y with g=1
        STATE_F  = 4'd8,  // g=1 permanent
        STATE_G  = 4'd9   // g=0 permanent
    } state_t;

    state_t state, next_state;

    // Sequential state transition
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: begin
                if (resetn)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                // After one cycle pulse f=1, move to wait for pattern x=1
                next_state = STATE_C0;
            end
            STATE_C0: begin
                // Waiting for x=1
                if (x == 1'b1)
                    next_state = STATE_C1;
                else
                    next_state = STATE_C0;
            end
            STATE_C1: begin
                // Waiting for x=0 next cycle
                if (x == 1'b0)
                    next_state = STATE_C2;
                else
                    next_state = STATE_C1;
            end
            STATE_C2: begin
                // Waiting for x=1 next cycle
                if (x == 1'b1)
                    next_state = STATE_D;
                else
                    next_state = STATE_C2;
            end
            STATE_D: begin
                // One cycle g=1 pulse
                next_state = STATE_E0;
            end
            STATE_E0: begin
                // Monitor y first cycle with g=1
                if (y == 1'b1)
                    next_state = STATE_F; // g=1 permanent
                else
                    next_state = STATE_E1; // next cycle monitoring y
            end
            STATE_E1: begin
                // Monitor y second cycle with g=1
                if (y == 1'b1)
                    next_state = STATE_F; // g=1 permanent
                else
                    next_state = STATE_G; // g=0 permanent
            end
            STATE_F: begin
                // g=1 permanent until reset
                next_state = STATE_F;
            end
            STATE_G: begin
                // g=0 permanent until reset
                next_state = STATE_G;
            end
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Output logic (Moore machine)
    always @(posedge clk) begin
        if (!resetn) begin
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            case (state)
                STATE_A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_B: begin
                    f <= 1'b1; // one cycle pulse after reset release
                    g <= 1'b0;
                end
                STATE_C0, STATE_C1, STATE_C2: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_D: begin
                    f <= 1'b0;
                    g <= 1'b1; // one cycle pulse g=1 after pattern
                end
                STATE_E0, STATE_E1: begin
                    f <= 1'b0;
                    g <= 1'b1; // monitor y with g=1
                end
                STATE_F: begin
                    f <= 1'b0;
                    g <= 1'b1; // g=1 permanent
                end
                STATE_G: begin
                    f <= 1'b0;
                    g <= 1'b0; // g=0 permanent
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

endmodule