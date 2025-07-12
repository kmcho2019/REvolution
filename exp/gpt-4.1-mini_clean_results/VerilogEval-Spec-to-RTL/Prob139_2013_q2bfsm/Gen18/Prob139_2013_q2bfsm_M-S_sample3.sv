module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        STATE_A = 3'd0, // Wait for reset release
        STATE_B = 3'd1, // Pulse f=1 one cycle
        STATE_C = 3'd2, // Monitor x for pattern 101
        STATE_D = 3'd3, // Pulse g=1 one cycle after pattern detected
        STATE_E = 3'd4, // Hold g=1, monitor y up to 2 cycles
        STATE_F = 3'd5, // g=1 permanently
        STATE_G = 3'd6  // g=0 permanently
    } state_t;

    reg [2:0] state, next_state;

    // Shift register to hold last 3 x inputs
    reg [2:0] x_shift;

    // Counter for monitoring y in STATE_E
    reg [1:0] y_cnt;

    // State register and synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            state    <= STATE_A;
            x_shift  <= 3'b000;
            y_cnt    <= 2'b00;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x every clock in STATE_C and later
            if (state == STATE_C) begin
                x_shift <= {x_shift[1:0], x};
            end else if (state == STATE_A || state == STATE_B) begin
                x_shift <= 3'b000;  // clear shift register in these states
            end

            // Update y counter only in STATE_E
            if (state == STATE_E) begin
                if (y == 1'b1) begin
                    y_cnt <= 2'b00; // reset counter if y=1 detected
                end else begin
                    y_cnt <= y_cnt + 1'b1; // increment count if y=0
                end
            end else begin
                y_cnt <= 2'b00; // reset counter outside STATE_E
            end

            // Update outputs f and g synchronously based on next_state
            case (next_state)
                STATE_A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_B: begin
                    f <= 1'b1;  // pulse f=1 for one cycle
                    g <= 1'b0;
                end
                STATE_C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                STATE_D: begin
                    f <= 1'b0;
                    g <= 1'b1;  // pulse g=1 for one cycle
                end
                STATE_E: begin
                    f <= 1'b0;
                    g <= 1'b1;  // hold g=1 while monitoring y
                end
                STATE_F: begin
                    f <= 1'b0;
                    g <= 1'b1;  // g=1 permanently
                end
                STATE_G: begin
                    f <= 1'b0;
                    g <= 1'b0;  // g=0 permanently
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
        case(state)
            STATE_A: begin
                // Wait for reset release
                // resetn is synchronous active low, so when resetn=1 FSM moves on
                if (resetn)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                // One cycle pulse f=1 then move to monitoring x
                next_state = STATE_C;
            end

            STATE_C: begin
                // Wait for pattern "101" in x_shift + current x
                // x_shift holds oldest 2 x samples; current x is newest
                if ({x_shift, x} == 3'b101)
                    next_state = STATE_D;
                else
                    next_state = STATE_C;
            end

            STATE_D: begin
                // One cycle pulse g=1 then move to y monitoring
                next_state = STATE_E;
            end

            STATE_E: begin
                // Monitor y for up to 2 cycles
                // If y=1 at any cycle -> go to STATE_F (g=1 permanently)
                // Else if 2 cycles passed without y=1 -> STATE_G (g=0 permanently)
                if (y == 1'b1)
                    next_state = STATE_F;
                else if (y_cnt == 2'd1)
                    next_state = STATE_G;
                else
                    next_state = STATE_E;
            end

            STATE_F: begin
                // g=1 permanently until reset
                next_state = STATE_F;
            end

            STATE_G: begin
                // g=0 permanently until reset
                next_state = STATE_G;
            end

            default: begin
                next_state = STATE_A;
            end
        endcase
    end

endmodule