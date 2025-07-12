module TopModule (
    input clk,
    input x,
    output z
);

    // D flip-flop outputs
    wire xor_out, and_out, or_out;
    reg dff_xor, dff_and, dff_or;

    // Combinational logic for gate inputs
    wire xor_in = x ^ dff_xor;
    wire and_in = x & ~dff_and;
    wire or_in = x | ~dff_or;

    // D flip-flops (positive edge triggered, initially 0)
    always @(posedge clk) begin
        dff_xor <= xor_in;
        dff_and <= and_in;
        dff_or <= or_in;
    end

    // Output logic (3-input NOR)
    assign z = ~(dff_xor | dff_and | dff_or);

endmodule