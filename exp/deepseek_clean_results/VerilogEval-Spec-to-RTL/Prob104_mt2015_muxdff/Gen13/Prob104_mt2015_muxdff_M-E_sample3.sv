module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input
    input r_in,    // Load input
    output reg Q   // Current state output
);

    // Position parameter (0, 1, or 2)
    parameter POSITION = 0;

    always @(posedge clk) begin
        if (L) begin
            // Load mode: simple register
            Q <= r_in;
        end else begin
            // Shift mode with position-specific operations
            case (POSITION)
                0: Q <= q_in;           // Bit 0 gets previous bit 1
                1: Q <= Q ^ q_in;       // Bit 1 gets XOR of bits 1 and 2
                2: Q <= q_in;           // Bit 2 gets previous bit 0
                default: Q <= q_in;
            endcase
        end
    end

endmodule