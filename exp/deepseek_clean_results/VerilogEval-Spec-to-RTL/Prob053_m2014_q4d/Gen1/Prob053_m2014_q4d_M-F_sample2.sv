module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage
    wire xor_out;

    // XOR gate combines input with current flip-flop state (not output)
    assign xor_out = in ^ q;

    // Positive edge-triggered D flip-flop
    always @(posedge clk) begin
        q <= xor_out;
    end

    // Output assignment remains the same
    assign out = q;

endmodule