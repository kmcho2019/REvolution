module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

// Synthesis attribute to infer flip-flop with synchronous reset (tool-specific)
// Example for Synopsys Synplify:
// (* syn_preserve = "true", syn_async_reset = "false" *)
//
// Or for Xilinx Vivado:
// (* IOB = "TRUE" *)
// These pragmas vary by tool and may be omitted if unsupported.

always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d;
end

// Optional simulation initialization
// Uncomment if simulation initialization is desired and supported
// initial q = 1'b0;

endmodule