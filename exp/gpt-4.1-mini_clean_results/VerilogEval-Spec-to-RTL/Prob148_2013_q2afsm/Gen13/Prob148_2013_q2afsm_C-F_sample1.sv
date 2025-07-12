module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2 bits)
    // A = 2'b00 (idle)
    // B = 2'b01 (grant device 0)
    // C = 2'b10 (grant device 1)
    // D = 2'b11 (grant device 2)
    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 2'b00;  // Reset to A (idle)
        else
            state <= next_state;
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            2'b00: begin // A (idle)
                if (r[0])
                    next_state = 2'b01;  // B: grant device 0
                else if (r[1])
                    next_state = 2'b10;  // C: grant device 1
                else if (r[2])
                    next_state = 2'b11;  // D: grant device 2
                else
                    next_state = 2'b00;  // Remain in idle
            end

            2'b01: // B: grant device 0
                next_state = r[0] ? 2'b01 : 2'b00;

            2'b10: // C: grant device 1
                next_state = r[1] ? 2'b10 : 2'b00;

            2'b11: // D: grant device 2
                next_state = r[2] ? 2'b11 : 2'b00;

            default:
                next_state = 2'b00;  // Safety fallback to idle
        endcase
    end

    // Output logic: derive grants directly from state bits using minimal logic
    assign g[0] = ~state[1] & state[0]; // grant device 0 (B)
    assign g[1] = state[1] & ~state[0]; // grant device 1 (C)
    assign g[2] = state[1] & state[0];  // grant device 2 (D)

endmodule