module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (2-bit binary):
    // 2'b00 = A (idle)
    // 2'b01 = B (grant device 0)
    // 2'b10 = C (grant device 1)
    // 2'b11 = D (grant device 2)
    reg [1:0] state, next_state;

    // Sequential block for state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // Reset to idle state A
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            2'b00: begin // Idle (A)
                if      (r[0])
                    next_state = 2'b01; // Grant device 0 (B)
                else if (r[1])
                    next_state = 2'b10; // Grant device 1 (C)
                else if (r[2])
                    next_state = 2'b11; // Grant device 2 (D)
                else
                    next_state = 2'b00; // Stay idle
            end

            2'b01: begin // Grant device 0 (B)
                // Stay if r0 persists else back to idle
                if (r[0])
                    next_state = 2'b01;
                else
                    next_state = 2'b00;
            end

            2'b10: begin // Grant device 1 (C)
                // Stay if r1 persists else back to idle
                if (r[1])
                    next_state = 2'b10;
                else
                    next_state = 2'b00;
            end

            2'b11: begin // Grant device 2 (D)
                // Stay if r2 persists else back to idle
                if (r[2])
                    next_state = 2'b11;
                else
                    next_state = 2'b00;
            end

            default: next_state = 2'b00; // Defensive: return to idle
        endcase
    end

    // Output combinational logic: grant signals based on state and active request
    // Ensures only one grant asserted matching FSM state and input request
    always @(*) begin
        case (state)
            2'b01: g = (r[0]) ? 3'b001 : 3'b000; // grant device 0 if request active
            2'b10: g = (r[1]) ? 3'b010 : 3'b000; // grant device 1 if request active
            2'b11: g = (r[2]) ? 3'b100 : 3'b000; // grant device 2 if request active
            default: g = 3'b000; // no grant in idle
        endcase
    end

endmodule