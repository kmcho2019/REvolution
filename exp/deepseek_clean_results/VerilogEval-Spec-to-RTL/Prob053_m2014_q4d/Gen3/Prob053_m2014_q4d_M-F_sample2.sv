module TopModule (
    input clk,
    input in,
    output out
);

    reg ff_out = 1'b0;  // Initialize to 0
    wire xor_out;

    // Combinational XOR logic
    assign xor_out = in ^ ff_out;

    // Sequential element (D flip-flop)
    always @(posedge clk) begin
        ff_out <= xor_out;
    end

    // Output assignment
    assign out = ff_out;

endmodule