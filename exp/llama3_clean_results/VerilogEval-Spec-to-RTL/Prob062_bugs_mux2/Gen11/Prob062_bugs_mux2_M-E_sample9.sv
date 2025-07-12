// Novel 8-bit 2-to-1 multiplexer module using a case statement
module TopModule (
    input        sel, // Select signal (1-bit)
    input  [7:0] a,   // First 8-bit input vector
    input  [7:0] b,   // Second 8-bit input vector
    output [7:0] out  // Selected 8-bit output vector
);

    always_comb begin
        case (sel)
            1'b0: out = a; // Select input vector a when sel is 0
            1'b1: out = b; // Select input vector b when sel is 1
            default: out = 8'b0; // Default to 0 when sel is unknown
        endcase
    end

    // Optional: Add assertions for input validation
    assert (sel == 1'b0 || sel == 1'b1) else $error("Invalid select signal value");

    // Optional: Use synthesis directives or attributes for optimization
    // (* syn_keep = 1 *) // Keeps the signal from being optimized away
    // (* syn_noclockbuf = 1 *) // Prevents insertion of a clock buffer

endmodule