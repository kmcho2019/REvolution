module TopModule (
    input clk,
    input in,
    output out
);

    wire xor_out;
    reg ff_out;

    // Combinational XOR logic
    assign xor_out = in ^ ff_out;

    // Positive edge-triggered flip-flop
    always @(posedge clk) begin
        ff_out <= xor_out;
    end

    // Output assignment
    assign out = ff_out;

endmodule