module TopModule (
    input clk,
    input a,
    output q
);
    reg q_dff;

    // Standard positive-edge triggered D flip-flop capturing 'a'
    always @(posedge clk) begin
        q_dff <= a;
    end

    // Combinationally invert stored value to produce q
    assign q = ~q_dff;

endmodule