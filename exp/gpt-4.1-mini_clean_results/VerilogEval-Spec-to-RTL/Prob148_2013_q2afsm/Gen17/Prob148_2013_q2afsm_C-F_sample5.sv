module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding: one-hot grants, zero means idle (A)
    // state[0] = grant device 0 (B)
    // state[1] = grant device 1 (C)
    // state[2] = grant device 2 (D)
    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 3'b000; // idle state A
        else
            state <= next_state;
    end

    // Next-state logic with priority encoding inside case statement
    always @(*) begin
        case (state)
            3'b000: begin // idle A
                if (r[0])
                    next_state = 3'b001; // B: grant device 0
                else if (r[1])
                    next_state = 3'b010; // C: grant device 1
                else if (r[2])
                    next_state = 3'b100; // D: grant device 2
                else
                    next_state = 3'b000; // remain idle
            end

            3'b001: // B: grant device 0
                next_state = r[0] ? 3'b001 : 3'b000;

            3'b010: // C: grant device 1
                next_state = r[1] ? 3'b010 : 3'b000;

            3'b100: // D: grant device 2
                next_state = r[2] ? 3'b100 : 3'b000;

            default:
                next_state = 3'b000; // safety fallback to idle
        endcase
    end

    // Output logic: directly from one-hot state bits
    always @(*) begin
        g = state;
    end

endmodule