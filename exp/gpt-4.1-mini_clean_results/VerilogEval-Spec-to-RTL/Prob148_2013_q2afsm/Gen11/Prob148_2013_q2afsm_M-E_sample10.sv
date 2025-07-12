module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding using one-hot for grants, 0 means idle (A)
    // state[0] = grant device 0 (B)
    // state[1] = grant device 1 (C)
    // state[2] = grant device 2 (D)
    reg [2:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 3'b000; // idle state A
        else
            state <= next_state;
    end

    // Next-state logic with priority on r[0], r[1], then r[2]
    always @(*) begin
        case (state)
            3'b000: begin // idle A
                if (r[0])
                    next_state = 3'b001; // B
                else if (r[1])
                    next_state = 3'b010; // C
                else if (r[2])
                    next_state = 3'b100; // D
                else
                    next_state = 3'b000; // remain idle
            end

            3'b001: // B grant device 0
                next_state = r[0] ? 3'b001 : 3'b000;

            3'b010: // C grant device 1
                next_state = r[1] ? 3'b010 : 3'b000;

            3'b100: // D grant device 2
                next_state = r[2] ? 3'b100 : 3'b000;

            default:
                next_state = 3'b000; // safety fallback to idle
        endcase
    end

    // Output logic: grant signals directly from one-hot state bits
    always @(*) begin
        g = 3'b000;
        g = state;
    end

endmodule