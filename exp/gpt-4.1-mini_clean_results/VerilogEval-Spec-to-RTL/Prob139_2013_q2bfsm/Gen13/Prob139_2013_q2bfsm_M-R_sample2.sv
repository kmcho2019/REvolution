module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active-low reset
    input  wire x,
    input  wire y,
    output wire f,
    output wire g
);

    // One-hot state encoding
    localparam A = 6'b000001;  // reset state
    localparam B = 6'b000010;  // f=1 for one cycle
    localparam C = 6'b000100;  // pattern detection
    localparam D = 6'b001000;  // g=1, monitor y
    localparam E = 6'b010000;  // g=1 permanently
    localparam F = 6'b100000;  // g=0 permanently

    reg [5:0] state, next_state;

    // Shift register for last 3 x inputs (valid in C and after)
    reg [2:0] x_shift;

    // 2-cycle timer for y monitoring (valid in D)
    reg [1:0] y_timer;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            x_shift <= 3'b000;
            y_timer <= 2'd0;
        end else begin
            state <= next_state;

            // Update x_shift only in C and D (pattern detection and y monitoring)
            // After moving to D, hold x_shift steady (no need to update)
            if (next_state == C) begin
                // Shift in new x
                x_shift <= {x_shift[1:0], x};
            end else if (next_state == D) begin
                // Hold x_shift steady in D
                x_shift <= x_shift;
            end else begin
                // Clear x_shift in other states to avoid false detection
                x_shift <= 3'b000;
            end

            // Update y_timer in D only
            if (next_state == D) begin
                if (y_timer < 2)
                    y_timer <= y_timer + 1'b1;
            end else begin
                y_timer <= 2'd0;
            end
        end
    end

    // Next-state combinational logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            A: begin
                if (resetn)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                // f=1 asserted one cycle, then go to pattern detection
                next_state = C;
            end
            C: begin
                // Detect pattern '101' in x_shift
                if (x_shift == 3'b101)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                // Monitor y for max 2 cycles
                if (y == 1'b1)
                    next_state = E;   // y detected: permanent g=1
                else if (y_timer >= 2)
                    next_state = F;   // timeout: permanent g=0
                else
                    next_state = D;
            end
            E: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end
            F: begin
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end
            default: next_state = A;
        endcase
    end

    // Output combinational logic (Moore machine)
    assign f = (state == B);
    assign g = (state == D) || (state == E);

endmodule