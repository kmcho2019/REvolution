module TopModule (
    input  wire clk,    // Clock input
    input  wire d,      // Data input
    input  wire r,      // Synchronous reset (active high)
    output reg  q       // Output register
);

    // Reset value parameter (could be made parameterizable)
    localparam RST_VAL = 1'b0;

    // Synchronous logic with reset
    always @(posedge clk) begin
        case (r)
            1'b1: q <= RST_VAL;  // Synchronous reset
            1'b0: q <= d;         // Normal operation
            default: q <= RST_VAL; // For simulation robustness
        endcase
    end

endmodule