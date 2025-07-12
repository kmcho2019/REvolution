module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding
localparam A  = 3'd0; // Reset state
localparam B  = 3'd1; // Output f=1 for one cycle after reset
localparam C0 = 3'd2; // Wait for x=1 first bit of pattern
localparam C1 = 3'd3; // Wait for x=0 second bit of pattern
localparam C2 = 3'd4; // Wait for x=1 third bit of pattern
localparam D  = 3'd5; // Output g=1 for one cycle after pattern detected
localparam E  = 3'd6; // Monitor y for up to two clocks, g=1 permanent if y=1
localparam F  = 3'd7; // g=0 permanent after timeout

reg [2:0] state, next_state;
reg [1:0] y_counter; // Count up to 2 cycles while monitoring y in state E

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        y_counter <= 2'd0;
    end else begin
        state <= next_state;
        // Update y_counter only in state E
        if (state == E) begin
            y_counter <= y_counter + 2'd1;
        end else begin
            y_counter <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: begin
            // Stay in A while resetn=0, move to B after resetn=1 on next clock
            if (resetn)
                next_state = B;
            else
                next_state = A;
        end
        B: begin
            // After one cycle output f=1, move to wait for pattern (C0)
            next_state = C0;
        end
        C0: begin
            // Wait for x=1 to start pattern
            if (x == 1'b1)
                next_state = C1;
            else
                next_state = C0;
        end
        C1: begin
            // Wait for x=0 after first 1
            if (x == 1'b0)
                next_state = C2;
            else if (x == 1'b1)
                next_state = C1; // Stay in C1 if x=1 (pattern reset not explicitly stated, but assume we wait)
            else
                next_state = C1; // Default to stay
        end
        C2: begin
            // Wait for x=1 to complete pattern
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                next_state = C0; // Pattern failed, restart waiting for first 1
            else
                next_state = C2;
        end
        D: begin
            // Output g=1 for one clock, then start monitoring y in E
            next_state = E;
        end
        E: begin
            // Stay here if y=1 within two clock cycles
            if (y == 1'b1)
                next_state = E; // Stay permanently with g=1
            else if (y_counter == 2'd2)
                next_state = F; // Timeout reached, set g=0 permanently
            else
                next_state = E; // Continue monitoring y
        end
        F: begin
            // g=0 permanently until reset
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    // Default outputs
    f = 1'b0;
    g = 1'b0;
    case(state)
        A: begin
            f = 1'b0;
            g = 1'b0;
        end
        B: begin
            f = 1'b1; // f=1 for one cycle
            g = 1'b0;
        end
        C0,C1,C2: begin
            f = 1'b0;
            g = 1'b0;
        end
        D: begin
            f = 1'b0;
            g = 1'b1; // g=1 for one cycle
        end
        E: begin
            f = 1'b0;
            g = 1'b1; // g=1 permanently while monitoring y=1 or timeout not reached
        end
        F: begin
            f = 1'b0;
            g = 1'b0; // g=0 permanently after timeout
        end
        default: begin
            f = 1'b0;
            g = 1'b0;
        end
    endcase
end

endmodule