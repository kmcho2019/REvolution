module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Internal register for the flip-flop state
    reg q_reg;

    // Sequential logic: D flip-flop triggered on positive edge of clk
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Output the current state of the flip-flop
    assign q = q_reg;
endmodule