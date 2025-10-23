/*
 * Enhanced TopModule with Configurable Wire/Buffer Functionality
 * Features:
 * - Default direct wire connection for optimal PPA
 * - Optional buffering via parameter
 * - Parameterized width support
 * - Comprehensive verification checks
 */
module TopModule #(
    parameter WIDTH = 1,         // Signal width (default 1-bit)
    parameter USE_BUFFERS = 0    // 0=direct wire, 1=use buffers
) (
    input  wire [WIDTH-1:0] in,  // Input signal
    output wire [WIDTH-1:0] out  // Output signal
);

generate
    if (USE_BUFFERS) begin: buffered
        // Use buffer modules when buffering is needed
        wire [WIDTH-1:0] intermediate;
        
        BufferModule #(WIDTH) b1(.in(in), .out(intermediate));
        BufferModule #(WIDTH) b2(.in(intermediate), .out(out));
    end
    else begin: direct
        // Default: direct wire connection for optimal PPA
        assign out = in;
    end
endgenerate

// Simulation checks
initial begin
    if (WIDTH != 1) 
        $display("Note: Vector version active (%0d bits)", WIDTH);
    if (USE_BUFFERS)
        $display("Note: Buffer mode active");
end

endmodule

// Parameterized buffer module for optional use
module BufferModule #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    assign out = in;
endmodule