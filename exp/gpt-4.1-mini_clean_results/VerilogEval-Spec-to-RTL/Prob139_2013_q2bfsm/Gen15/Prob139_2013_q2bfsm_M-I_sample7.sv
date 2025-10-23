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

            // Update x_shift only in state C; otherwise clear it
            if (state == C)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            // Update y_count only in state E; otherwise clear it
            if (state == E)
                y_count <= y_count + 1'b1;
            else
                y_count <= 2'b00;

            // Outputs are Moore type driven by current state
            case (state)
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
        // Default to hold state
        next_state = state;

        // Synchronous reset: stay in A while resetn is low
        if (!resetn) begin
            next_state = A;
        end else begin
            case(state)
                A: begin
                    // On release of reset, move to B for one cycle
                    next_state = B;
                end

                B: begin
                    // one cycle pulse f=1, then start pattern detection
                    next_state = C;
                end

                C: begin
                    // monitor x pattern "101"
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
                        // After two clock cycles in E (counts 0 and 1), no y=1 detected
                        next_state = G; // g=0 permanently
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
    end

endmodule