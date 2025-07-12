module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (binary):
    // 2'b00 = A (idle)
    // 2'b01 = B (grant device 0)
    // 2'b10 = C (grant device 1)
    // 2'b11 = D (grant device 2)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00; // reset to A (idle)
        else
            state <= next_state;
    end

    // Next state logic with priority on r[0], then r[1], then r[2]
    always @(*) begin
        case (state)
            2'b00: begin // A: idle
                if (r[0])
                    next_state = 2'b01; // grant 0
                else if (r[1])
                    next_state = 2'b10; // grant 1
                else if (r[2])
                    next_state = 2'b11; // grant 2
                else
                    next_state = 2'b00; // stay idle
            end

            2'b01: // B: grant device 0
                next_state = r[0] ? 2'b01 : 2'b00;

            2'b10: // C: grant device 1
                next_state = r[1] ? 2'b10 : 2'b00;

            2'b11: // D: grant device 2
                next_state = r[2] ? 2'b11 : 2'b00;

            default:
                next_state = 2'b00; // safe fallback to idle
        endcase
    end

    // Output logic: grant signals asserted based on state
    // g[0] = 1 if state == B (01)
    // g[1] = 1 if state == C (10)
    // g[2] = 1 if state == D (11)
    assign g = (state == 2'b01) ? 3'b001 :
               (state == 2'b10) ? 3'b010 :
               (state == 2'b11) ? 3'b100 :
                                  3'b000;

endmodule