module TopModule (
    input clk,
    input in,
    output out
);

    reg state;

    // Combinational XOR of input and current state
    wire d;
    assign d = in ^ state;

    // Flip-flop capturing XOR result
    always @(posedge clk) begin
        state <= d;
    end

    // Output driven by XOR of input and flip-flop state
    assign out = d;

endmodule