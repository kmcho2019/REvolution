module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        STATE_A = 3'd0,  // reset state
        STATE_B = 3'd1,  // f=1 one cycle after resetn deasserted
        STATE_C = 3'd2,  // monitor x pattern 101 using shift register
        STATE_D = 3'd3,  // pulse g=1 one cycle
        STATE_E = 3'd4,  // monitor y input for up to 2 cycles with g=1
        STATE_F = 3'd5,  // permanent g=1
        STATE_G = 3'd6;  // permanent g=0

    reg [2:0] state, next_state;

    // Shift register to hold last 3 values of x in STATE_C
    reg [2:0] x_shift;

    // 2-bit counter to monitor y in STATE_E (counts 0,1,2 cycles)
    reg [1:0] y_cnt;

    // Sequential block: update state, x_shift, y_cnt synchronously
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= STATE_A;
            x_shift <= 3'b000;
            y_cnt   <= 2'b00;
        end else begin
            state <= next_state;
            // Update x_shift only in STATE_C, else clear
            if (state == STATE_C) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end
            // y_cnt handling: reset when entering STATE_E, increment in STATE_E, else zero
            if (state != STATE_E && next_state == STATE_E) begin
                y_cnt <= 2'b00;          // reset counter on entry to E
            end else if (state == STATE_E) begin
                y_cnt <= y_cnt + 1'b1;   // increment counter in E
            end else begin
                y_cnt <= 2'b00;
            end
        end
    end

    // Combinational block: next state logic depends only on current state, x_shift, y, y_cnt
    always @(*) begin
        next_state = state;  // default to hold
        case(state)
            STATE_A: begin
                // Hold in reset state while resetn is low; once resetn high move to B
                if (resetn)
                    next_state = STATE_B;
            end
            STATE_B: begin
                // f=1 for one cycle, then move to monitoring pattern of x in C
                next_state = STATE_C;
            end
            STATE_C: begin
                // Wait for pattern 101 on x_shift (3-bit shift register)
                if (x_shift == 3'b101)
                    next_state = STATE_D;
            end
            STATE_D: begin
                // One cycle pulse g=1, then go to monitor y input in E
                next_state = STATE_E;
            end
            STATE_E: begin
                // Monitor y for up to 2 cycles, while g=1
                if (y == 1'b1)
                    next_state = STATE_F;  // permanent g=1
                else if (y_cnt == 2'd2)
                    next_state = STATE_G;  // permanent g=0
            end
            STATE_F: begin
                // Permanent g=1 state until reset
                next_state = STATE_F;
            end
            STATE_G: begin
                // Permanent g=0 state until reset
                next_state = STATE_G;
            end
            default: next_state = STATE_A;
        endcase
    end

    // Output logic: Moore outputs depend only on current state
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case(state)
            STATE_B: f = 1'b1;                // f=1 for one cycle in B
            STATE_D: g = 1'b1;                // g=1 one cycle pulse in D
            STATE_E: g = 1'b1;                // g=1 while monitoring y in E
            STATE_F: g = 1'b1;                // g=1 permanent in F
            // g=0 in all other states by default
        endcase
    end

endmodule