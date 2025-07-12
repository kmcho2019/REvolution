module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0, // Reset / initial state
        B = 3'd1, // f=1 one cycle after reset released
        C = 3'd2, // Monitor x pattern 101
        D = 3'd3, // g=1 one cycle pulse after pattern detected
        E = 3'd4, // Monitor y for up to 2 cycles, g=1 during this
        F = 3'd5, // g=1 permanently (y=1 detected in time)
        G = 3'd6  // g=0 permanently (y not detected in time)
    } state_t;

    state_t state, next_state;

    reg [2:0] x_shift;     // shift register for x input (3 bits)
    reg [1:0] y_count;     // counter for y detection (max 2)

    // Sequential logic: state register, x_shift, y_count
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state <= next_state;

            // Shift x every cycle to keep a continuous sliding window of last 3 x inputs
            x_shift <= {x_shift[1:0], x};

            // y_count management
            if (state == E) begin
                y_count <= y_count + 2'd1;
            end else begin
                y_count <= 2'd0;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // default hold
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: next_state = C; // one cycle f=1 pulse
            C: begin
                // Check if last 3 x inputs are 101
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: next_state = E; // one cycle g=1 pulse
            E: begin
                if (y)
                    next_state = F;        // y detected in time, permanent g=1
                else if (y_count == 2'd1) 
                    // y_count == 1 means E state for 2 cycles: counts 0 and 1 -> at 1, two cycles elapsed
                    next_state = G;        // timeout, y not detected, permanent g=0
                else
                    next_state = E;        // keep monitoring y
            end
            F: next_state = F;              // hold permanently
            G: next_state = G;              // hold permanently
            default: next_state = A;
        endcase
    end

    // Output logic (combinational Moore outputs)
    // f = 1 only in state B for one cycle after reset release
    // g = 1 in states D, E, and F; 0 otherwise
    assign f = (state == B);
    assign g = (state == D) || (state == E) || (state == F);

endmodule