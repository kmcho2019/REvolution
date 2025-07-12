module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2-bit binary):
    // 2'b00: A (idle)
    // 2'b01: B (grant device 0)
    // 2'b10: C (grant device 1)
    // 2'b11: D (grant device 2)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // reset to state A (idle)
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            2'b00: begin // idle (A)
                // Priority: device 0 > device 1 > device 2
                if      (r[0]) next_state = 2'b01; // grant device 0
                else if (r[1]) next_state = 2'b10; // grant device 1
                else if (r[2]) next_state = 2'b11; // grant device 2
                else           next_state = 2'b00; // remain idle
            end

            2'b01: begin // grant device 0 (B)
                if (r[0])
                    next_state = 2'b01; // stay granting device 0
                else
                    next_state = 2'b00; // return to idle
            end

            2'b10: begin // grant device 1 (C)
                if (r[1])
                    next_state = 2'b10; // stay granting device 1
                else
                    next_state = 2'b00; // return to idle
            end

            2'b11: begin // grant device 2 (D)
                if (r[2])
                    next_state = 2'b11; // stay granting device 2
                else
                    next_state = 2'b00; // return to idle
            end

            default: begin
                next_state = 2'b00; // Defensive fallback to idle
            end
        endcase
    end

    // Output logic: grant signals asserted based on state
    // Only one bit of g is set corresponding to granted device
    assign g = (state == 2'b01) ? 3'b001 :   // grant device 0
               (state == 2'b10) ? 3'b010 :   // grant device 1
               (state == 2'b11) ? 3'b100 :   // grant device 2
                                  3'b000;    // idle: no grant

endmodule