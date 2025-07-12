module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    
    wire xor_in, and_in, or_in;

    // Combinational logic for gate inputs
    assign xor_in = x ^ xor_ff;      // XOR with own output
    assign and_in = x & ~and_ff;     // AND with complemented output
    assign or_in  = x | ~or_ff;      // OR with complemented output

    // Sequential logic with initial zero state
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff  <= or_in;
    end

    // Output logic - three-input NOR
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule