module TopModule (
    input  wire clk,
    input  wire d,
    output wire q
);
    // Internal register holds the flip-flop state
    reg q_reg;

    // Sequential logic: update q_reg on positive edge of clk
    always @(posedge clk) begin
        q_reg <= d;
    end

    // Output is continuously assigned from registered state
    assign q = q_reg;
endmodule