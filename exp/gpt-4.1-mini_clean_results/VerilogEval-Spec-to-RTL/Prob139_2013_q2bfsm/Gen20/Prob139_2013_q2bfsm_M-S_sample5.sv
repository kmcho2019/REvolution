module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        STATE_A = 3'd0, // reset state, f=0, g=0
        STATE_B = 3'd1, // f=1 pulse (one cycle)
        STATE_C = 3'd2, // monitor x for pattern 101
        STATE_D = 3'd3, // g=1 pulse (one cycle)
        STATE_E = 3'd4, // monitor y up to 2 cycles with g=1
        STATE_F = 3'd5, // permanent g=1
        STATE_G = 3'd6  // permanent g=0
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;    // last three x inputs for pattern detection
    reg [1:0] y_count;    // count cycles monitoring y (0 or 1)

    // Sequential logic: state, registers updated on posedge clk with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            x_shift <= 3'b000;
            y_count <= 2'b00;
        end else begin
            state <= next_state;

            case (state)
                STATE_A: begin
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
                STATE_B: begin
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
                STATE_C: begin
                    // Shift in x samples each cycle
                    x_shift <= {x_shift[1:0], x};
                    y_count <= 2'b00;
                end
                STATE_D: begin
                    // g pulse done, prepare to monitor y
                    x_shift <= x_shift; // hold
                    y_count <= 2'b00;
                end
                STATE_E: begin
                    x_shift <= x_shift; // hold
                    y_count <= y_count + 1'b1;
                end
                STATE_F, STATE_G: begin
                    // hold x_shift and y_count
                    x_shift <= x_shift;
                    y_count <= y_count;
                end
                default: begin
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            STATE_A: if (resetn) next_state = STATE_B;
            STATE_B: next_state = STATE_C;
            STATE_C: begin
                // Wait for pattern 101 in x_shift
                if (x_shift == 3'b101)
                    next_state = STATE_D;
                else
                    next_state = STATE_C;
            end
            STATE_D: next_state = STATE_E;
            STATE_E: begin
                if (y == 1'b1)
                    next_state = STATE_F;
                else if (y_count == 2'd1)
                    next_state = STATE_G;
                else
                    next_state = STATE_E;
            end
            STATE_F: next_state = STATE_F;
            STATE_G: next_state = STATE_G;
            default: next_state = STATE_A;
        endcase
    end

    // Moore output logic
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case (state)
            STATE_B: f = 1'b1; // one-cycle pulse after reset release
            STATE_D: g = 1'b1; // one-cycle pulse after pattern detection
            STATE_E: g = 1'b1; // hold g=1 while monitoring y
            STATE_F: g = 1'b1; // permanent g=1
            // g=0 elsewhere
        endcase
    end

endmodule