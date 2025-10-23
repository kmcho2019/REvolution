module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding (binary):
    // 2'b00 = A (idle)
    // 2'b01 = B (grant device 0)
    // 2'b10 = C (grant device 1)
    // 2'b11 = D (grant device 2)
    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00;  // Reset to idle (A)
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            2'b00: begin // A: idle
                // Priority: r[0] > r[1] > r[2]
                if (r[0])
                    next_state = 2'b01; // B: grant device 0
                else if (r[1])
                    next_state = 2'b10; // C: grant device 1
                else if (r[2])
                    next_state = 2'b11; // D: grant device 2
                else
                    next_state = 2'b00; // Remain in idle
            end

            2'b01: begin // B: grant device 0
                // Stay if r[0] persists, else back to idle
                if (r[0])
                    next_state = 2'b01;
                else
                    next_state = 2'b00;
            end

            2'b10: begin // C: grant device 1
                // Stay if r[1] persists, else back to idle
                if (r[1])
                    next_state = 2'b10;
                else
                    next_state = 2'b00;
            end

            2'b11: begin // D: grant device 2
                // Stay if r[2] persists, else back to idle
                if (r[2])
                    next_state = 2'b11;
                else
                    next_state = 2'b00;
            end

            default: begin
                // Defensive fallback to idle
                next_state = 2'b00;
            end
        endcase
    end

    // Output logic: grant signals depend on state
    always @(*) begin
        case (state)
            2'b00: g = 3'b000;    // no grant in idle (A)
            2'b01: g = 3'b001;    // grant device 0 (B)
            2'b10: g = 3'b010;    // grant device 1 (C)
            2'b11: g = 3'b100;    // grant device 2 (D)
            default: g = 3'b000;  // safety fallback
        endcase
    end

endmodule