module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using localparam for synthesis clarity
    localparam A = 3'd0; // reset state, f=0, g=0
    localparam B = 3'd1; // f=1 for one cycle
    localparam C = 3'd2; // monitor x pattern (shift register)
    localparam D = 3'd3; // g=1 pulse for one cycle after pattern detection
    localparam E = 3'd4; // hold g=1, monitor y up to 2 cycles
    localparam F = 3'd5; // g=1 permanent
    localparam G = 3'd6; // g=0 permanent

    reg [2:0] state, next_state;

    // Shift register for x inputs (sampled)
    reg [2:0] x_shift;

    // y monitor cycle counter (max 2 cycles)
    reg [1:0] y_count;

    // Registered inputs to avoid glitches and align timing
    reg x_reg, y_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            // Synchronous reset active low: hold in state A, outputs 0
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'b00;
            f        <= 1'b0;
            g        <= 1'b0;
            x_reg    <= 1'b0;
            y_reg    <= 1'b0;
        end else begin
            // Register inputs
            x_reg <= x;
            y_reg <= y;

            state <= next_state;

            case (state)
                A: begin
                    // outputs zero, clear registers
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                B: begin
                    // f=1 for one cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                C: begin
                    // f=0, g=0, shift in x_reg (sampled x)
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= {x_shift[1:0], x_reg};
                    y_count <= 2'b00;
                end

                D: begin
                    // g=1 pulse one cycle
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                E: begin
                    // g=1 hold, monitor y_reg
                    f <= 1'b0;
                    g <= 1'b1;

                    // x_shift not needed here
                    x_shift <= 3'b000;

                    // increment y_count if y=0; reset if y=1
                    if (y_reg == 1'b1) begin
                        y_count <= 2'b00; // reset counter if y=1 detected
                    end else begin
                        y_count <= y_count + 1'b1;
                    end
                end

                F: begin
                    // g=1 permanent
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                G: begin
                    // g=0 permanent
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end

                default: begin
                    // safe defaults
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'b00;
                end
            endcase
        end
    end

    // Next state logic purely combinational but based on registered inputs and state
    always @(*) begin
        // default hold state
        next_state = state;

        case(state)
            A: begin
                // Wait for reset release; move to B at next clock after resetn=1
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After pulsing f=1, move to pattern monitor state
                next_state = C;
            end

            C: begin
                // Detect pattern 101 in x_shift after shift register updated
                // Pattern detection uses sampled x inputs registered in x_shift synchronously
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // One cycle g=1 pulse after pattern detected, then monitor y
                next_state = E;
            end

            E: begin
                // Monitor y for up to two cycles
                // If y=1 detected, go to permanent g=1 state F
                if (y_reg == 1'b1) begin
                    next_state = F;
                end
                else if (y_count == 2'd2) begin
                    // 2 cycles passed without y=1 -> go to g=0 permanent G
                    next_state = G;
                end else begin
                    next_state = E;
                end
            end

            F: begin
                // Hold g=1 permanent until reset
                next_state = F;
            end

            G: begin
                // Hold g=0 permanent until reset
                next_state = G;
            end

            default: begin
                next_state = A;
            end
        endcase
    end

endmodule