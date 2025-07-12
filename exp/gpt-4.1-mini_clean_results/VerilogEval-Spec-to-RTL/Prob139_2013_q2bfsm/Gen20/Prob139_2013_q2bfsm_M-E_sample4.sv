module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // One-hot state encoding
    localparam A = 7'b0000001; // reset state, f=0, g=0
    localparam B = 7'b0000010; // f=1 one cycle
    localparam C = 7'b0000100; // monitor x pattern
    localparam D = 7'b0001000; // g=1 one cycle
    localparam E = 7'b0010000; // g=1 hold, monitor y for 2 cycles
    localparam F = 7'b0100000; // g=1 permanent
    localparam G = 7'b1000000; // g=0 permanent

    reg [6:0] state, next_state;

    // Shift register to hold last 3 x values, updated in state C
    reg [2:0] x_shift, next_x_shift;

    // Counter for y monitoring cycles in state E (0 to 2)
    reg [1:0] y_count, next_y_count;

    // Sequential state and registers update with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn) begin
            state      <= A;
            x_shift    <= 3'b000;
            y_count    <= 2'd0;
            f          <= 1'b0;
            g          <= 1'b0;
        end else begin
            state      <= next_state;
            x_shift    <= next_x_shift;
            y_count    <= next_y_count;
            f          <= (next_state == B) ? 1'b1 : 1'b0; // f=1 only in state B
            g          <= (next_state == D) || (next_state == E) || (next_state == F);
        end
    end

    // Combinational logic for next state and registers
    always @(*) begin
        // Defaults to hold current values
        next_state   = state;
        next_x_shift = x_shift;
        next_y_count = y_count;

        case (state)
            A: begin
                // Wait in A while resetn is low (handled in sequential)
                // When resetn is high, go to B at next clock
                next_state = B;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            B: begin
                // One-cycle f=1 pulse, then start monitoring x
                next_state = C;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            C: begin
                // Shift in x to x_shift register
                next_x_shift = {x_shift[1:0], x};
                next_y_count = 2'd0;

                // Detect pattern 1,0,1 in last 3 x values
                // That means x_shift after shift == 3'b101
                if ({x_shift[1:0], x} == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end

            D: begin
                // One cycle g=1 pulse, then monitor y with g=1 hold
                next_state = E;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            E: begin
                // Hold g=1, monitor y for up to 2 cycles
                next_x_shift = 3'b000;

                if (y) begin
                    // y=1 detected, permanent g=1
                    next_state = F;
                    next_y_count = 2'd0;
                end else if (y_count == 2'd1) begin
                    // After two cycles without y=1, permanent g=0
                    next_state = G;
                    next_y_count = 2'd0;
                end else begin
                    // Increment y_count and stay in E
                    next_state = E;
                    next_y_count = y_count + 1'b1;
                end
            end

            F: begin
                // g=1 permanent until reset
                next_state = F;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            G: begin
                // g=0 permanent until reset
                next_state = G;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end

            default: begin
                // Recover to reset state on invalid state
                next_state = A;
                next_x_shift = 3'b000;
                next_y_count = 2'd0;
            end
        endcase
    end

endmodule