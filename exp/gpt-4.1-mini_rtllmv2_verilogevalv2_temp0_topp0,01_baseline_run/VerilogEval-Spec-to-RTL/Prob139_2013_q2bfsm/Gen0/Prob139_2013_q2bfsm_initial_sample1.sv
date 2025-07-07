module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum reg [3:0] {
        A = 4'd0,      // Reset state
        B = 4'd1,      // f=1 for one cycle
        X1 = 4'd2,     // waiting for x=1 (first bit of sequence)
        X2 = 4'd3,     // waiting for x=0 (second bit)
        X3 = 4'd4,     // waiting for x=1 (third bit)
        G_ON = 4'd5,   // g=1, monitoring y for up to 2 cycles
        G_OFF = 4'd6   // g=0 permanently
    } state_t;

    state_t state, next_state;

    reg [1:0] y_counter; // counts up to 2 cycles monitoring y in G_ON

    // Sequential state and output update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
            y_counter <= 0;
        end else begin
            state <= next_state;
            case (next_state)
                A: begin
                    f <= 0;
                    g <= 0;
                    y_counter <= 0;
                end
                B: begin
                    f <= 1;
                    g <= 0;
                    y_counter <= 0;
                end
                X1: begin
                    f <= 0;
                    g <= 0;
                    y_counter <= 0;
                end
                X2: begin
                    f <= 0;
                    g <= 0;
                    y_counter <= 0;
                end
                X3: begin
                    f <= 0;
                    g <= 0;
                    y_counter <= 0;
                end
                G_ON: begin
                    f <= 0;
                    g <= 1;
                    // y_counter updated below
                end
                G_OFF: begin
                    f <= 0;
                    g <= 0;
                    y_counter <= 0;
                end
                default: begin
                    f <= 0;
                    g <= 0;
                    y_counter <= 0;
                end
            endcase

            // Update y_counter only in G_ON state
            if (state == G_ON) begin
                if (y == 1) begin
                    y_counter <= 0; // reset counter if y=1
                end else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                end
            end else begin
                y_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // After one cycle with f=1, start monitoring x sequence
                next_state = X1;
            end
            X1: begin
                // Wait for x=1 to start sequence
                if (x == 1)
                    next_state = X2;
                else
                    next_state = X1;
            end
            X2: begin
                // Wait for x=0 next
                if (x == 0)
                    next_state = X3;
                else if (x == 1)
                    next_state = X2; // stay here if x=1, waiting for 0
                else
                    next_state = X1; // restart sequence if x != 0 or 1 (shouldn't happen)
            end
            X3: begin
                // Wait for x=1 to complete sequence
                if (x == 1)
                    next_state = G_ON;
                else if (x == 0)
                    next_state = X1; // restart sequence if x=0
                else
                    next_state = X1; // restart sequence otherwise
            end
            G_ON: begin
                // g=1, monitor y for up to 2 cycles
                if (y == 1) begin
                    // y=1 within 2 cycles, stay here permanently
                    next_state = G_ON;
                end else if (y_counter == 2) begin
                    // y not 1 within 2 cycles, go to G_OFF
                    next_state = G_OFF;
                end else begin
                    // keep monitoring
                    next_state = G_ON;
                end
            end
            G_OFF: begin
                // g=0 permanently until reset
                next_state = G_OFF;
            end
            default: next_state = A;
        endcase
    end

endmodule