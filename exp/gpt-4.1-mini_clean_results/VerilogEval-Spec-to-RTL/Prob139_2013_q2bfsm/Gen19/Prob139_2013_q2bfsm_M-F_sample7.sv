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
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse after reset
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1 pulse after pattern detected
        E = 3'd4, // g=1 hold, monitor y for 2 cycles
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    reg [2:0] state, next_state;
    reg [2:0] x_shift, next_x_shift;
    reg [1:0] y_count, next_y_count;
    reg next_f, next_g;

    // Sequential logic: state, shift register, counter, outputs update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state   <= next_state;
            x_shift <= next_x_shift;
            y_count <= next_y_count;
            f       <= next_f;
            g       <= next_g;
        end
    end

    // Combinational logic: next state, outputs and internal registers
    always @(*) begin
        // Default assignments to hold current values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;
        next_f       = 1'b0;
        next_g       = 1'b0;

        case(state)
            A: begin
                // Stay in A while reset asserted
                // When reset released (handled outside by sequential logic), move to B
                next_state   = B;
                // outputs low
                next_f       = 1'b0;
                next_g       = 1'b0;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            B: begin
                // One cycle pulse of f=1
                next_f       = 1'b1;
                next_g       = 1'b0;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
                next_state   = C;
            end

            C: begin
                // Shift in x input to x_shift register
                next_x_shift = {x_shift[1:0], x};
                next_f       = 1'b0;
                next_g       = 1'b0;
                next_y_count = 2'd0;

                // Check for pattern 1,0,1 in updated x_shift
                if ({x_shift[1:0], x} == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // g=1 pulse for 1 clock cycle
                next_f       = 1'b0;
                next_g       = 1'b1;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
                next_state   = E;
            end

            E: begin
                // Hold g=1, monitor y for up to two cycles
                next_f = 1'b0;
                next_g = 1'b1;

                next_x_shift = 3'b000; // no x monitoring here

                if (y == 1'b1) begin
                    // y=1 within two cycles: permanent g=1
                    next_y_count = 2'd0;
                    next_state = F;
                end else if (y_count == 2'd1) begin
                    // 2 cycles elapsed without y=1: permanent g=0
                    next_y_count = 2'd0;
                    next_state = G;
                end else begin
                    // Increment y_count and stay in E
                    next_y_count = y_count + 1'b1;
                    next_state = E;
                end
            end

            F: begin
                // g=1 permanent
                next_f       = 1'b0;
                next_g       = 1'b1;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
                next_state   = F;
            end

            G: begin
                // g=0 permanent
                next_f       = 1'b0;
                next_g       = 1'b0;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
                next_state   = G;
            end

            default: begin
                // Safe default: go to reset state
                next_state   = A;
                next_f       = 1'b0;
                next_g       = 1'b0;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

endmodule