module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (2-bit binary):
    // 00: A (idle)
    // 01: B (grant device 0)
    // 10: C (grant device 1)
    // 11: D (grant device 2)
    reg [1:0] state, next_state;

    // Sequential logic: state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= 2'b00; // idle state A
        else
            state <= next_state;
    end

    // Combinational logic: next state with blocking assignments
    always @(*) begin
        next_state = state; // default hold current state

        case (state)
            2'b00: begin // idle state A
                // Grant highest priority request if any
                if      (r[0]) next_state = 2'b01; // grant device 0 (B)
                else if (r[1]) next_state = 2'b10; // grant device 1 (C)
                else if (r[2]) next_state = 2'b11; // grant device 2 (D)
                else           next_state = 2'b00; // remain idle
            end

            2'b01: begin // grant device 0 (B)
                if (!r[0])
                    next_state = 2'b00; // release grant, return to idle
                else
                    next_state = 2'b01; // sustain grant
            end

            2'b10: begin // grant device 1 (C)
                if (!r[1])
                    next_state = 2'b00; // release grant, return to idle
                else
                    next_state = 2'b10; // sustain grant
            end

            2'b11: begin // grant device 2 (D)
                if (!r[2])
                    next_state = 2'b00; // release grant, return to idle
                else
                    next_state = 2'b11; // sustain grant
            end

            default: next_state = 2'b00; // safety fallback
        endcase
    end

    // Output grant signals derived from state bits:
    // g[0] = grant device 0 = state == B = 2'b01
    // g[1] = grant device 1 = state == C = 2'b10
    // g[2] = grant device 2 = state == D = 2'b11
    assign g[0] = ~state[1] &  state[0];
    assign g[1] =  state[1] & ~state[0];
    assign g[2] =  state[1] &  state[0];

endmodule