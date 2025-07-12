module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // State encoding (binary, 2 bits):
    // 2'b00: A (idle)
    // 2'b01: B (grant device 0)
    // 2'b10: C (grant device 1)
    // 2'b11: D (grant device 2)
    reg [1:0] state, next_state;

    // State encoding parameters for readability
    localparam A = 2'b00,
               B = 2'b01,
               C = 2'b10,
               D = 2'b11;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic with priority and sustain logic
    always @(*) begin
        case (state)
            A: begin // idle
                if      (r[0]) next_state = B; // grant device 0
                else if (r[1]) next_state = C; // grant device 1
                else if (r[2]) next_state = D; // grant device 2
                else           next_state = A; // stay idle
            end

            B: begin // grant device 0
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end

            C: begin // grant device 1
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end

            D: begin // grant device 2
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            default: begin
                // Defensive: reset to idle if invalid state
                next_state = A;
            end
        endcase
    end

    // Output logic: grants decoded from state
    // Only one grant bit high according to current state:
    // g[0] = 1 if state == B
    // g[1] = 1 if state == C
    // g[2] = 1 if state == D
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule