module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs (initialized to 0 as per problem requirements)
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;
    
    // Combinational gate logic
    wire xor_in = x ^ xor_ff;
    wire and_in = x & ~and_ff;
    wire or_in = x | ~or_ff;
    
    // Sequential logic (positive edge triggered)
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end
    
    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule