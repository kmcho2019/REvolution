module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'b000, // reset state
        B = 3'b001, // output f=1 for 1 cycle
        C0 = 3'b010, // monitor x=1 (first in sequence)
        C1 = 3'b011, // monitor x=0 (second in sequence)
        C2 = 3'b100, // monitor x=1 (third in sequence)
        D = 3'b101,  // g=1, monitor y up to two cycles
        E = 3'b110,  // y=1 detected, g=1 permanently
        F = 3'b111   // y=1 not detected in time, g=0 permanently
    } state_t;

    state_t state, next_state;

    // Counter to track y monitoring cycles in state D (0,1,2)
    reg [1:0] y_counter;

    // Sequential logic: state and y_counter update
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            y_counter <= 2'd0;
        end else begin
            state <= next_state;
            if (state == D)
                y_counter <= y_counter + 2'd1;
            else
                y_counter <= 2'd0;
        end
    end

    // Combinational logic: next state and output logic
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;
        next_state = state;

        case (state)
            A: begin
                // reset asserted, remain here
                f = 1'b0;
                g = 1'b0;
                if (resetn)
                    next_state = B;
            end

            B: begin
                // output f=1 one cycle
                f = 1'b1;
                g = 1'b0;
                next_state = C0;
            end

            // Monitor x sequence 1,0,1 over three clocks
            C0: begin
                f = 1'b0;
                g = 1'b0;
                if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0; // keep waiting for 1
            end

            C1: begin
                f = 1'b0;
                g = 1'b0;
                if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1; // still wait for 0, but if 1 again, remain in C1 (no strict reset)
                else
                    next_state = C0; // fallback, but x is 1 bit so no else needed
            end

            C2: begin
                f = 1'b0;
                g = 1'b0;
                if (x == 1'b1)
                    next_state = D;
                else if (x == 1'b0)
                    next_state = C0; // restart sequence wait from beginning
            end

            D: begin
                // g=1, monitor y input for up to two cycles
                f = 1'b0;
                g = 1'b1;
                if (y == 1'b1)
                    next_state = E;
                else if (y_counter == 2'd1) // after two cycles (0 and 1 counting)
                    next_state = F;
                else
                    next_state = D;
            end

            E: begin
                // g=1 permanently until reset
                f = 1'b0;
                g = 1'b1;
                next_state = E;
            end

            F: begin
                // g=0 permanently until reset
                f = 1'b0;
                g = 1'b0;
                next_state = F;
            end

            default: begin
                f = 1'b0;
                g = 1'b0;
                next_state = A;
            end
        endcase
    end

endmodule