module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

    // One-hot state encoding (4 bits)
    // A = 4'b0001 (Idle)
    // B = 4'b0010 (Grant device 0)
    // C = 4'b0100 (Grant device 1)
    // D = 4'b1000 (Grant device 2)
    reg [3:0] state, next_state;

    // Synchronous state register with active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= 4'b0001; // Reset to state A
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        // Default to no change
        next_state = 4'b0000;
        case (state)
            4'b0001: begin // State A (Idle)
                // Priority encoder for requests
                if (r[0])
                    next_state = 4'b0010; // B - grant r0
                else if (r[1])
                    next_state = 4'b0100; // C - grant r1
                else if (r[2])
                    next_state = 4'b1000; // D - grant r2
                else
                    next_state = 4'b0001; // remain in A
            end

            4'b0010: // State B - grant device 0
                next_state = r[0] ? 4'b0010 : 4'b0001;

            4'b0100: // State C - grant device 1
                next_state = r[1] ? 4'b0100 : 4'b0001;

            4'b1000: // State D - grant device 2
                next_state = r[2] ? 4'b1000 : 4'b0001;

            default:
                next_state = 4'b0001; // Safety fallback to A
        endcase
    end

    // Output logic - grant signals driven by state bits
    // g[0] = 1 when in B; g[1] = 1 when in C; g[2] = 1 when in D
    assign g = { state[3], state[2], state[1] };

endmodule