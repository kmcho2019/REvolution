module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (3-bit one-hot):
    // 3'b000: Idle state A (no grants)
    // 3'b001: Grant device 0 (state B)
    // 3'b010: Grant device 1 (state C)
    // 3'b100: Grant device 2 (state D)
    reg [2:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 3'b000;  // idle state A
        else
            state <= next_state;
    end

    // Next state combinational logic with priority and sustain logic
    always @(*) begin
        case (state)
            3'b000: begin // idle (A)
                // Priority: device 0 > device 1 > device 2
                if      (r[0]) next_state = 3'b001; // grant device 0 (B)
                else if (r[1]) next_state = 3'b010; // grant device 1 (C)
                else if (r[2]) next_state = 3'b100; // grant device 2 (D)
                else           next_state = 3'b000; // remain idle
            end

            3'b001: begin // grant device 0 (B)
                // Stay granted if r[0] persists, else return idle
                if (r[0])
                    next_state = 3'b001;
                else
                    next_state = 3'b000;
            end

            3'b010: begin // grant device 1 (C)
                // Stay granted if r[1] persists, else return idle
                if (r[1])
                    next_state = 3'b010;
                else
                    next_state = 3'b000;
            end

            3'b100: begin // grant device 2 (D)
                // Stay granted if r[2] persists, else return idle
                if (r[2])
                    next_state = 3'b100;
                else
                    next_state = 3'b000;
            end

            default: begin
                // Defensive: return to idle on illegal state
                next_state = 3'b000;
            end
        endcase
    end

    // Output grant signals correspond directly to grant states
    assign g = state;

endmodule