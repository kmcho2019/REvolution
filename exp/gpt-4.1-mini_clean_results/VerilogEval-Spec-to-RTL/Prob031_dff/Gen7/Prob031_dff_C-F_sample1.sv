// D flip-flop module with positive edge clock triggering
module DFF (
    input clk,      // Clock input
    input d,        // Data input
    output reg q    // Output register
);
    always @(posedge clk) begin
        q <= d;    // Non-blocking assignment for correct sequential behavior
    end
endmodule

// Top module instantiating the DFF module directly
module TopModule (
    input clk,      // Clock input
    input d,        // Data input
    output q        // Output of the D flip-flop
);
    // Instantiate DFF, connecting inputs and output directly
    DFF dff_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule