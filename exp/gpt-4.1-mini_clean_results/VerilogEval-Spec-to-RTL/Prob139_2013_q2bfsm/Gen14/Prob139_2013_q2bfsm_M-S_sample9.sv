module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding (one-hot style for clarity)
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 for one cycle after reset release
        C = 3'd2, // monitor x pattern 101
        D = 3'd3, // g=1 pulse for one cycle after pattern
        E = 3'd4, // monitor y for 2 cycles with g=1
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    reg [2:0] state, next_state;

    reg [2:0] x_shift; // shift register to track last 3 x values
    reg [1:0] y_count; // count cycles y monitored in state E

    // Synchronous state and registers update with synchronous active low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            state   <= next_state;
            x_shift <= (next_state == C) ? {x_shift[1:0], x} : 3'b000;
            y_count <= (next_state == E) ? y_count + 1'b1 : 2'd0;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        case(state)
            A: begin
                if (resetn)
                    next_state = B;
            end
            B: begin
                next_state = C;
            end
            C: begin
                // Detect pattern 1 0 1 in x_shift (shifted with new x this cycle)
                if ({x_shift[1:0], x} == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                next_state = E;
            end
            E: begin
                if (y == 1'b1)
                    next_state = F;
                else if (y_count == 2'd1) // after two cycles of monitoring y without 1
                    next_state = G;
                else
                    next_state = E;
            end
            F: begin
                next_state = F;
            end
            G: begin
                next_state = G;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    // Moore output logic
    always @(*) begin
        f = 1'b0;
        g = 1'b0;
        case(state)
            B: f = 1'b1;
            D: g = 1'b1;
            E: g = 1'b1;
            F: g = 1'b1;
            default: begin
                // f=0, g=0
            end
        endcase
    end

endmodule