module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage
    wire xor_out;

    // XOR gate combining input and current output
    assign xor_out = in ^ out;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        q <= xor_out;
    end

    assign out = q;

endmodule