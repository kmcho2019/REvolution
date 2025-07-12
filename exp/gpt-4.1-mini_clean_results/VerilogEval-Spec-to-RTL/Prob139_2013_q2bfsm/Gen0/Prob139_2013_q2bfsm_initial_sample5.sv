module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

    // State encoding
    localparam A = 3'd0,  // initial/reset state
               B = 3'd1,  // f=1 one cycle after reset release
               C0 = 3'd2, // waiting for x=1 (start of sequence)
               C1 = 3'd3, // x=0 detected after first 1
               C2 = 3'd4, // x=1 detected after 1,0 sequence
               D = 3'd5,  // g=1, monitor y for 2 clock cycles
               E = 3'd6,  // g=1 permanently (y=1 detected)
               F = 3'd7;  // g=0 permanently (timeout on y)

    reg [2:0] state, next_state;
    reg [1:0] y_counter; // counts up to 2 cycles while waiting for y=1 in D state

    // State register
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        // default to current state
        next_state = state;

        case (state)
            A: begin
                // Wait for reset release
                if (resetn)
                    next_state = B; // on next clk after resetn deasserted
                else
                    next_state = A;
            end
            B: begin
                // After output f=1 one cycle, move to monitor x sequence
                next_state = C0;
            end
            C0: begin
                // Looking for x=1 to start pattern
                if (!resetn)
                    next_state = A;
                else if (x == 1'b1)
                    next_state = C1;
                else
                    next_state = C0; // keep waiting for x=1
            end
            C1: begin
                // Wait for x=0 after x=1
                if (!resetn)
                    next_state = A;
                else if (x == 1'b0)
                    next_state = C2;
                else if (x == 1'b1)
                    next_state = C1; // repeated 1, stay here
                else
                    next_state = C0; // no match, restart pattern
            end
            C2: begin
                // Wait for x=1 to complete pattern 1,0,1
                if (!resetn)
                    next_state = A;
                else if (x == 1'b1)
                    next_state = D; // pattern matched
                else if (x == 1'b0)
                    next_state = C0; // restart pattern
                else
                    next_state = C0;
            end
            D: begin
                // g=1, monitor y for up to 2 cycles
                if (!resetn)
                    next_state = A;
                else if (y == 1'b1)
                    next_state = E; // y=1 detected, permanent g=1
                else if (y_counter == 2'd2)
                    next_state = F; // timeout no y=1 within 2 cycles, g=0 permanently
                else
                    next_state = D; // keep waiting
            end
            E: begin
                // permanent g=1 until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end
            F: begin
                // permanent g=0 until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end
            default: next_state = A;
        endcase
    end

    // y_counter logic for state D
    always @(posedge clk) begin
        if (!resetn)
            y_counter <= 2'd0;
        else if (state == D) begin
            if (y == 1'b1)
                y_counter <= 2'd0;
            else if (y_counter < 2'd2)
                y_counter <= y_counter + 1;
        end else
            y_counter <= 2'd0;
    end

    // Output logic
    always @(*) begin
        // Default outputs
        f = 1'b0;
        g = 1'b0;

        case (state)
            B: f = 1'b1; // f=1 for one cycle after reset released
            D: g = 1'b1;
            E: g = 1'b1;
            F: g = 1'b0;
            default: begin
                f = 1'b0;
                g = 1'b0;
            end
        endcase
    end

endmodule