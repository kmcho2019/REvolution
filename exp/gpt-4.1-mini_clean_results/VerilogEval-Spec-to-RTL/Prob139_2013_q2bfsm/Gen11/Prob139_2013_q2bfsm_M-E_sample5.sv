module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // One-hot states for clarity
    localparam A = 6'b000001; // Reset state
    localparam B = 6'b000010; // Assert f=1 for one cycle
    localparam C = 6'b000100; // Pattern detection: watch x for 101
    localparam D = 6'b001000; // Pattern found: g=1, start monitoring y
    localparam E = 6'b010000; // y=1 detected within 2 cycles, g=1 permanent
    localparam F = 6'b100000; // Timeout without y=1, g=0 permanent

    reg [5:0] state, next_state;

    // Shift register to hold last 3 x inputs, updated only in state C
    reg [2:0] x_shift;

    // 2-cycle counter for y monitoring in state D
    reg [1:0] y_timer;

    // Sequential logic: state, x_shift, y_timer
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_timer <= 2'b00;
            f       <= 1'b0;
            g       <= 1'b0;
        end else begin
            state <= next_state;

            case (next_state)
                A: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_timer <= 2'b00;
                end
                B: begin
                    // Assert f=1 for one cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_timer <= 2'b00;
                end
                C: begin
                    // f=0, g=0 in pattern detection
                    f <= 1'b0;
                    g <= 1'b0;
                    // Shift in x input every clock
                    x_shift <= {x_shift[1:0], x};
                    y_timer <= 2'b00;
                end
                D: begin
                    // g=1 while monitoring y, f=0
                    f <= 1'b0;
                    g <= 1'b1;
                    // hold x_shift steady
                    x_shift <= x_shift;
                    // Increment y_timer if less than 2
                    if (y_timer < 2)
                        y_timer <= y_timer + 1'b1;
                end
                E: begin
                    // g=1 permanent, f=0
                    f <= 1'b0;
                    g <= 1'b1;
                    // hold registers steady
                    x_shift <= x_shift;
                    y_timer <= y_timer;
                end
                F: begin
                    // g=0 permanent, f=0
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= x_shift;
                    y_timer <= y_timer;
                end
                default: begin
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_timer <= 2'b00;
                end
            endcase
        end
    end

    // Next-state logic combinational
    always @(*) begin
        next_state = state;  // default hold state

        case(state)
            A: begin
                if (resetn)
                    next_state = B; // After reset released, move to f=1 assertion
                else
                    next_state = A;
            end
            B: begin
                // After one cycle asserting f=1, move to pattern detection
                next_state = C;
            end
            C: begin
                // Detect pattern "101" on x_shift
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // Monitor y input for up to 2 cycles
                if (y == 1'b1)
                    next_state = E; // y detected within time
                else if (y_timer >= 2)
                    next_state = F; // y timeout
                else
                    next_state = D; // continue monitoring
            end
            E: begin
                // Stay here forever until reset
                next_state = E;
            end
            F: begin
                // Stay here forever until reset
                next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule