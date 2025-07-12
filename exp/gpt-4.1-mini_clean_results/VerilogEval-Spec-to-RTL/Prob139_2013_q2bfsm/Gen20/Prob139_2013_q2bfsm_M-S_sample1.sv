module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam A = 3'd0; // reset state
    localparam B = 3'd1; // f=1 pulse after reset
    localparam C = 3'd2; // monitor x pattern 1,0,1
    localparam D = 3'd3; // g=1 pulse after pattern detected
    localparam E = 3'd4; // g=1 hold, monitor y for up to 2 cycles
    localparam F = 3'd5; // g=1 permanent
    localparam G = 3'd6; // g=0 permanent

    reg [2:0] state, next_state;

    // 3-bit shift register to track last 3 x samples
    reg [2:0] x_shift_reg, x_shift_next;

    // 2-bit counter to count y monitoring cycles in E
    reg [1:0] y_count, y_count_next;

    // Sequential logic: state, x_shift_reg, y_count update
    always @(posedge clk) begin
        if (!resetn) begin
            state       <= A;
            x_shift_reg <= 3'b000;
            y_count     <= 2'b00;
        end else begin
            state       <= next_state;
            x_shift_reg <= x_shift_next;
            y_count     <= y_count_next;
        end
    end

    // Combinational logic: next state and outputs
    always @(*) begin
        // Defaults
        next_state    = state;
        x_shift_next  = x_shift_reg;
        y_count_next  = y_count;
        f             = 1'b0;
        g             = 1'b0;

        case(state)
            A: begin
                // Wait in A while resetn=0 (handled in sequential)
                // On resetn=1, move to B
                next_state = B;
            end

            B: begin
                // One cycle pulse f=1 after reset
                f = 1'b1;
                // Clear shift register and counters
                x_shift_next = 3'b000;
                y_count_next = 2'b00;
                next_state = C;
            end

            C: begin
                // Shift in x, monitor for pattern 1,0,1
                x_shift_next = {x_shift_reg[1:0], x};

                // Check pattern after shift
                if ({x_shift_reg[1:0], x} == 3'b101) begin
                    next_state = D;
                end else begin
                    next_state = C;
                end
            end

            D: begin
                // One cycle pulse g=1 after pattern detected
                g = 1'b1;
                // Reset y_count for monitoring y in next state
                y_count_next = 2'b00;
                // x_shift not needed here, clear it
                x_shift_next = 3'b000;
                next_state = E;
            end

            E: begin
                // Hold g=1
                g = 1'b1;

                // Monitor y input for up to 2 cycles after entering E
                if (y == 1'b1) begin
                    // y=1 detected within allowed cycles => permanent g=1
                    next_state = F;
                    y_count_next = 2'b00;
                end else if (y_count == 2'b01) begin
                    // Already waited 2 cycles (counting 0 and 1), y=1 not detected
                    next_state = G;
                    y_count_next = 2'b00;
                end else begin
                    // Increment counter, stay in E
                    y_count_next = y_count + 1'b1;
                    next_state = E;
                end

                // x_shift not needed in E
                x_shift_next = 3'b000;
            end

            F: begin
                // g=1 permanent hold
                g = 1'b1;
                next_state = F;
                x_shift_next = 3'b000;
                y_count_next = 2'b00;
            end

            G: begin
                // g=0 permanent hold
                g = 1'b0;
                next_state = G;
                x_shift_next = 3'b000;
                y_count_next = 2'b00;
            end

            default: begin
                // Safety fallback to reset state
                next_state = A;
                x_shift_next = 3'b000;
                y_count_next = 2'b00;
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule