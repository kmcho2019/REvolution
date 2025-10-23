module TopModule(
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse
        C = 3'd2, // monitor x for pattern 101
        D = 3'd3, // g=1 pulse
        E = 3'd4, // monitor y up to 2 cycles with g=1
        F = 3'd5, // g=1 permanently
        G = 3'd6; // g=0 permanently

    reg [2:0] state, next_state;
    reg [2:0] x_shift;      // shift register for x input pattern detection
    reg [1:0] y_count;      // counts cycles monitoring y in state E

    // Sequential logic: state, x_shift, y_count, outputs updated on clk posedge
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_count <= 2'b00;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            // Shift in x only if in C (pattern monitoring) or reset x_shift otherwise
            if (next_state == C)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            // Update y_count only in E, else reset
            if (next_state == E)
                y_count <= y_count + 1'b1;
            else
                y_count <= 2'b00;

            // Moore outputs assigned based on current state
            case (next_state)
                A: begin f <= 1'b0; g <= 1'b0; end
                B: begin f <= 1'b1; g <= 1'b0; end
                C: begin f <= 1'b0; g <= 1'b0; end
                D: begin f <= 1'b0; g <= 1'b1; end
                E: begin f <= 1'b0; g <= 1'b1; end
                F: begin f <= 1'b0; g <= 1'b1; end
                G: begin f <= 1'b0; g <= 1'b0; end
                default: begin f <= 1'b0; g <= 1'b0; end
            endcase
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = state;
        case(state)
            A: begin
                // stay in A while reset asserted; else move to B after resetn de-asserted synchronously
                // resetn synchronous, so after resetn=1 on clock edge, move to B
                next_state = B;
            end

            B: begin
                // one cycle pulse f=1, then start pattern detection
                next_state = C;
            end

            C: begin
                // monitor x pattern "101"
                // Check pattern in x_shift after shift (shift occurs next clock), so check current x_shift
                if (x_shift == 3'b101)
                    next_state = D; // pattern detected
                else
                    next_state = C; // keep monitoring
            end

            D: begin
                // one cycle pulse g=1, then monitor y with g=1 up to 2 cycles
                next_state = E;
            end

            E: begin
                // g=1, monitor y for up to 2 cycles
                if (y == 1'b1) begin
                    next_state = F; // y detected, g=1 permanently
                end else if (y_count == 2'd1) begin
                    // y_count increments after entering E, after second cycle (count==1, zero-based)
                    next_state = G; // y not detected within 2 cycles, g=0 permanently
                end else begin
                    next_state = E; // continue monitoring y
                end
            end

            F: begin
                // g=1 permanently until reset
                next_state = F;
            end

            G: begin
                // g=0 permanently until reset
                next_state = G;
            end

            default: next_state = A;
        endcase
    end

endmodule