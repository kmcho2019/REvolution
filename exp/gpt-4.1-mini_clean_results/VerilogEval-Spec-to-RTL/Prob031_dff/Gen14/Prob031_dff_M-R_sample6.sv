module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);

    // Internal register to hold flip-flop state
    reg q_reg;

    // Positive edge-triggered flip-flop implemented inline
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Output is a wire driven by internal register
    assign q = q_reg;

endmodule