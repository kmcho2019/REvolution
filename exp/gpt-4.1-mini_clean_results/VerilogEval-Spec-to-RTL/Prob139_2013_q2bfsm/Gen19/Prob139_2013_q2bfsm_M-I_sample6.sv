module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding using one-hot style for optimization
    localparam A = 3'd0; // reset state
    localparam B = 3'd1; // f=1 pulse after reset
    localparam C = 3'd2; // monitor x pattern 1,0,1
    localparam D = 3'd3; // g=1 pulse after pattern detected
    localparam E = 3'd4; // g=1 hold, monitor y for 2 cycles
    localparam F = 3'd5; // g=1 permanent
    localparam G = 3'd6; // g=0 permanent

    reg [2:0] state, next_state;

    // Shift register for last 3 x samples
    reg [2:0] x_shift_reg, x_shift_next;

    // Counter for y monitoring (0 to 2)
    reg [1:0] y_count, y_count_next;

    // Sequential logic: state, x_shift_reg, y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state       <= A;
            x_shift_reg <= 3'b000;
            y_count     <= 2'd0;
        end else begin
            state       <= next_state;
            x_shift_reg <= x_shift_next;
            y_count     <= y_count_next;
        end
    end

    // Combinational logic: next state and outputs
    always @(*) begin
        // Defaults
        next_state = state;
        x_shift_next = x_shift_reg;
        y_count_next = y_count;
        f = 1'b0;
        g = 1'b0;

        case(state)
            A: begin
                // Hold in A while resetn=0 (handled in sequential reset)
                // Upon resetn=1, move to B
                next_state = B;
                // Outputs remain 0
            end

            B: begin
                // One cycle pulse f=1 after reset
                f = 1'b1;
                // Move to C next cycle
                next_state = C;
                // Reset shift register and counters for fresh pattern detection
                x_shift_next = 3'b000;
                y_count_next = 2'd0;
            end

            C: begin
                // Shift in current x input
                x_shift_next = {x_shift_reg[1:0], x};
                // Monitor x pattern 1,0,1
                // After shift, if last 3 bits == 3'b101, go to D
                if ({x_shift_reg[1:0], x} == 3'b101) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
                // Outputs zero
                f = 1'b0;
                g = 1'b0;
                y_count_next = 2'd0;
            end

            D: begin
                // One cycle pulse g=1 immediately after pattern detection
                g = 1'b1;
                // Clear x_shift and y_count, prepare to monitor y
                x_shift_next = 3'b000;
                y_count_next = 2'd0;
                // Move to E for y monitoring
                next_state = E;
            end

            E: begin
                // Hold g=1
                g = 1'b1;
                // Monitor y input for up to two cycles after entering E
                if (y == 1'b1) begin
                    // y=1 detected within 2 cycles -> hold g=1 permanently
                    next_state = F;
                    y_count_next = 2'd0;
                end else if (y_count == 2'd1) begin
                    // Already waited 2 cycles without y=1, move to g=0 permanent
                    next_state = G;
                    y_count_next = 2'd0;
                end else begin
                    // Increment y_count and stay in E
                    y_count_next = y_count + 1'b1;
                    next_state = E;
                end
                // x_shift unused here
                x_shift_next = 3'b000;
                f = 1'b0;
            end

            F: begin
                // g=1 permanent hold
                g = 1'b1;
                // Remain in F until reset
                next_state = F;
                x_shift_next = 3'b000;
                y_count_next = 2'd0;
                f = 1'b0;
            end

            G: begin
                // g=0 permanent hold
                g = 1'b0;
                // Remain in G until reset
                next_state = G;
                x_shift_next = 3'b000;
                y_count_next = 2'd0;
                f = 1'b0;
            end

            default: begin
                // Safety fallback to reset state
                next_state = A;
                x_shift_next = 3'b000;
                y_count_next = 2'd0;
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule