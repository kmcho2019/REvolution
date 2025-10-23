module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (4-bit one-hot)
    // A (idle) = 4'b0001 (bit 0)
    // B (grant device 0) = 4'b0010 (bit 1)
    // C (grant device 1) = 4'b0100 (bit 2)
    // D (grant device 2) = 4'b1000 (bit 3)
    reg [3:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // Reset to A (idle)
        else
            state <= next_state;
    end

    // Next-state logic with priority and hold grants
    always @(*) begin
        case (state)
            4'b0001: begin // A (idle)
                if (r[0])
                    next_state = 4'b0010; // B: grant device 0
                else if (r[1])
                    next_state = 4'b0100; // C: grant device 1
                else if (r[2])
                    next_state = 4'b1000; // D: grant device 2
                else
                    next_state = 4'b0001; // Remain idle
            end

            4'b0010: // B (grant device 0)
                next_state = r[0] ? 4'b0010 : 4'b0001;

            4'b0100: // C (grant device 1)
                next_state = r[1] ? 4'b0100 : 4'b0001;

            4'b1000: // D (grant device 2)
                next_state = r[2] ? 4'b1000 : 4'b0001;

            default:
                next_state = 4'b0001; // Safety fallback to idle
        endcase
    end

    // Output logic: grant signals directly from state bits (B, C, D)
    assign g = {state[3], state[2], state[1]};

endmodule