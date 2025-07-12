module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0,  // Reset state
        B = 3'd1,  // Pulse f=1 one cycle after reset release
        C = 3'd2,  // Monitor x input sequence
        D = 3'd3,  // g=1, monitor y for up to 2 cycles
        E = 3'd4,  // Hold g=1 permanently
        F = 3'd5   // Hold g=0 permanently
    } state_t;

    state_t state, next_state;

    // Registers to hold previous two x inputs for pattern detection
    reg x_reg1, x_reg2;

    // Counter for y monitoring in state D (0 to 2)
    reg [1:0] y_timer;

    // Sequential logic: state update, x shift registers, y timer, outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_reg1 <= 1'b0;
            x_reg2 <= 1'b0;
            y_timer <= 2'd0;
            f <= 1'b0;
            g <= 1'b0;
        end else begin
            state <= next_state;

            // Update previous x inputs only in states B or later
            // Because in A FSM is reset, in B we start pulse and store inputs for sequence detection in C
            if (state >= B) begin
                x_reg2 <= x_reg1;
                x_reg1 <= x;
            end else begin
                x_reg1 <= 1'b0;
                x_reg2 <= 1'b0;
            end

            // Update y_timer only in state D
            if (state == D) begin
                y_timer <= y_timer + 1'b1;
            end else begin
                y_timer <= 2'd0;
            end

            // Moore outputs depend on current state only
            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                B: begin
                    f <= 1'b1;  // pulse f=1 for exactly one cycle after reset release
                    g <= 1'b0;
                end
                C: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                D: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                E: begin
                    f <= 1'b0;
                    g <= 1'b1;
                end
                F: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic: determine next state
    always @(*) begin
        next_state = state;

        case (state)
            A: begin
                // Stay in A while resetn is low, move to B on release
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // After one cycle pulse on f, move to C to monitor x
                next_state = C;
            end

            C: begin
                // Check if the sequence 1 0 1 is present on (x_reg2,x_reg1,x)
                if ({x_reg2, x_reg1, x} == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // In D, g=1; wait for y=1 for up to 2 cycles
                if (y == 1'b1)
                    next_state = E;      // y detected within time, hold g=1 forever
                else if (y_timer == 2'd2)
                    next_state = F;      // timeout expired, hold g=0 forever
                else
                    next_state = D;      // keep waiting
            end

            E: begin
                // Hold g=1 forever until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end

            F: begin
                // Hold g=0 forever until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end

            default: next_state = A;
        endcase
    end

endmodule