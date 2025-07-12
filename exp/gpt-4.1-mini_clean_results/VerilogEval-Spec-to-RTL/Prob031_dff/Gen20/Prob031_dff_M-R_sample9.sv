module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Internal register to hold DFF state
    reg q_reg;

    // Sequential logic: positive edge-triggered D flip-flop
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Output driven by internal register
    assign q = q_reg;

endmodule