module TopModule (
    input  wire clk,
    input  wire resetn, // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam A = 3'd0; // Reset state, wait for resetn deasserted
    localparam B = 3'd1; // Output f=1 pulse
    localparam C = 3'd2; // Monitor x pattern via shift register
    localparam D = 3'd3; // Output g=1 pulse
    localparam E = 3'd4; // Hold g=1, monitor y for 2 cycles max
    localparam F = 3'd5; // Permanent g=1
    localparam G = 3'd6; // Permanent g=0

    reg [2:0] state, next_state;
    reg [2:0] x_shift;    // shift register for last 3 x inputs
    reg [1:0] y_monitor_counter; // counts cycles monitoring y in state E

    // State register update (sequential)
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_shift <= 3'b000;
            y_monitor_counter <= 2'd0;
        end else begin
            state <= next_state;

            // Shift in current x input every cycle except when in reset or g pulse states (to avoid false detection)
            // But safer to shift in x every cycle except reset, so pattern detection is continuous
            if (state != A)
                x_shift <= {x_shift[1:0], x};
            else
                x_shift <= 3'b000;

            // Increment or reset y_monitor_counter only in E, else reset
            if (state == E) begin
                y_monitor_counter <= y_monitor_counter + 1'b1;
            end else begin
                y_monitor_counter <= 2'd0;
            end
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = state; // default hold

        case(state)
            A: begin
                // Remain here while resetn == 0
                if (resetn)
                    next_state = B;
            end

            B: begin
                // After one cycle f=1 pulse, move to C to monitor x pattern
                next_state = C;
            end

            C: begin
                // Wait until pattern 101 detected on x_shift (last three x inputs)
                // x_shift is updated with new x input at posedge, so pattern in x_shift is current
                if (x_shift == 3'b101)
                    next_state = D;
            end

            D: begin
                // One cycle g=1 pulse, then move to E to hold and monitor y
                next_state = E;
            end

            E: begin
                // Hold g=1, monitor y input for up to 2 cycles (cycles counted from 0 to 1)
                // If y==1 detected, go to F to hold g=1 permanently
                // If two cycles elapsed without y==1, go to G to hold g=0 permanently

                if (y == 1'b1)
                    next_state = F;
                else if (y_monitor_counter == 2'd1)
                    next_state = G;
            end

            F: begin
                // Hold g=1 permanently until reset
                next_state = F;
            end

            G: begin
                // Hold g=0 permanently until reset
                next_state = G;
            end

            default: next_state = A;
        endcase
    end

    // Output logic (combinational)
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;

        case(state)
            A: begin
                // Reset state outputs zero
                f = 1'b0;
                g = 1'b0;
            end

            B: begin
                // f=1 pulse one cycle
                f = 1'b1;
                g = 1'b0;
            end

            C: begin
                // Waiting for pattern; outputs zero
                f = 1'b0;
                g = 1'b0;
            end

            D: begin
                // g=1 pulse one cycle
                f = 1'b0;
                g = 1'b1;
            end

            E: begin
                // Hold g=1, f=0
                f = 1'b0;
                g = 1'b1;
            end

            F: begin
                // Permanent g=1, f=0
                f = 1'b0;
                g = 1'b1;
            end

            G: begin
                // Permanent g=0, f=0
                f = 1'b0;
                g = 1'b0;
            end

            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule