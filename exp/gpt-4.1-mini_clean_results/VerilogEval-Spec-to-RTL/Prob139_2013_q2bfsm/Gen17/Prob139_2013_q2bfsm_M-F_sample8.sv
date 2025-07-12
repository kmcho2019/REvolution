module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    typedef enum logic [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 one cycle after reset released
        C = 3'd2, // monitor x pattern 101
        D = 3'd3, // g=1 one cycle pulse after pattern detected
        E = 3'd4, // monitor y for 2 cycles while g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6  // g=0 permanently
    } state_t;

    state_t state, next_state;
    reg [2:0] x_shift;
    reg [1:0] y_count;

    // State register and outputs update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'b00;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Shift x only in states C, D, E, F, G (monitoring phase)
            if (state == C || state == D || state == E || state == F || state == G) begin
                x_shift <= {x_shift[1:0], x};
            end else begin
                x_shift <= 3'b000;
            end

            // Update y_count only in state E (monitoring y)
            if (state == E) begin
                y_count <= y_count + 1'b1;
            end else begin
                y_count <= 2'b00;
            end

            // Outputs based on current state (Moore)
            case (state)
                B: begin f <= 1'b1; g <= 1'b0; end
                D: begin f <= 1'b0; g <= 1'b1; end
                E: begin f <= 1'b0; g <= 1'b1; end
                F: begin f <= 1'b0; g <= 1'b1; end
                G: begin f <= 1'b0; g <= 1'b0; end
                default: begin f <= 1'b0; g <= 1'b0; end
            endcase
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: next_state = C; // one cycle f=1
            C: begin
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: next_state = E; // one cycle g=1 pulse
            E: begin
                if (y)
                    next_state = F; // y=1 detected within 2 cycles
                else if (y_count == 2'd1)
                    next_state = G; // y not detected after 2 cycles
                else
                    next_state = E;
            end
            F: next_state = F; // hold g=1 permanently
            G: next_state = G; // hold g=0 permanently
            default: next_state = A;
        endcase
    end

endmodule