module TopModule (
    input clk,
    input in,
    output out
);

    wire xor_out;
    reg d_out = 1'b0;  // Initialize to 0

    // Combinational XOR logic
    assign xor_out = in ^ out;

    // Sequential flip-flop
    always @(posedge clk) begin
        d_out <= xor_out;
    end

    // Output assignment
    assign out = d_out;

endmodule