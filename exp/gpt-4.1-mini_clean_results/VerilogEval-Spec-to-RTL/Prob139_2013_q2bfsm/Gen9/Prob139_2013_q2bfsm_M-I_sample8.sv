module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    parameter A              = 3'd0; // Reset state
    parameter F_PULSE        = 3'd1; // f=1 pulse after reset release
    parameter MONITOR_X      = 3'd2; // Monitor x input pattern 1,0,1
    parameter G_ON_MONITOR_Y = 3'd3; // g=1, monitor y up to 2 cycles
    parameter G_ON_PERM      = 3'd4; // g=1 permanently
    parameter G_OFF_PERM     = 3'd5; // g=0 permanently

    reg [2:0] state, next_state;

    // Delayed resetn for edge detection
    reg resetn_d;

    // Shift register for pattern detection (3 bits)
    reg [2:0] x_shift;

    // Counter for y monitoring (max 2 cycles)
    reg [1:0] y_count;

    // Detect reset release as wire outside procedural blocks
    wire reset_release = resetn & ~resetn_d;

    // Sequential block: state and registers update
    always @(posedge clk) begin
        resetn_d <= resetn;

        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'd0;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            state <= next_state;

            // Update f output: pulse high only in F_PULSE state
            f <= (next_state == F_PULSE) ? 1'b1 : 1'b0;

            // Update g output: high in G_ON_MONITOR_Y and G_ON_PERM states
            case (next_state)
                G_ON_MONITOR_Y,
                G_ON_PERM: g <= 1'b1;
                default:  g <= 1'b0;
            endcase

            // Update x_shift register only in MONITOR_X state
            if (next_state == MONITOR_X)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000; // reset shift register outside MONITOR_X

            // Update y_count only in G_ON_MONITOR_Y state
            if (next_state == G_ON_MONITOR_Y)
                y_count <= y_count + 1'b1;
            else
                y_count <= 2'd0;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                if (reset_release)
                    next_state = F_PULSE;
                else
                    next_state = A;
            end

            F_PULSE: next_state = MONITOR_X;

            MONITOR_X: begin
                // Detect pattern 1,0,1 in x_shift
                if (x_shift == 3'b101)
                    next_state = G_ON_MONITOR_Y;
                else
                    next_state = MONITOR_X;
            end

            G_ON_MONITOR_Y: begin
                if (y == 1'b1)
                    next_state = G_ON_PERM;
                else if (y_count >= 2'd2)
                    next_state = G_OFF_PERM;
                else
                    next_state = G_ON_MONITOR_Y;
            end

            G_ON_PERM: next_state = G_ON_PERM;

            G_OFF_PERM: next_state = G_OFF_PERM;

            default: next_state = A;
        endcase
    end

endmodule