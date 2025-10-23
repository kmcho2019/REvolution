// Improved 8-bit 2-to-1 multiplexer module
module TopModule (
    input        sel, // Select signal
    input  [7:0] a,   // First 8-bit input
    input  [7:0] b,   // Second 8-bit input
    output [7:0] out  // Selected 8-bit output
);

    // Check if 'sel' is a valid binary value
    wire valid_sel = (sel == 1'b0) || (sel == 1'b1);

    // Use a case statement for explicit multiplexing
    always @(sel, a, b) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // Default to zero if 'sel' is unknown
        endcase
    end

    // Alternatively, use an if-else statement for multiplexing
    // always @(sel, a, b) begin
    //     if (sel == 1'b0) begin
    //         out = a;
    //     end else if (sel == 1'b1) begin
    //         out = b;
    //     end else begin
    //         out = 8'b0; // Default to zero if 'sel' is unknown
    //     end
    // end

endmodule