module TopModule (
    input clk,    // Optional clock for registered version
    input a,
    input b,
    input c,
    input d,
    output reg q  // Changed to reg for registered version
);

    // Combinational version (uncomment if needed)
    // assign q = (a | b) & (c | d);

    // Registered version for power optimization
    always @(posedge clk) begin
        q <= (a | b) & (c | d);
    end

endmodule