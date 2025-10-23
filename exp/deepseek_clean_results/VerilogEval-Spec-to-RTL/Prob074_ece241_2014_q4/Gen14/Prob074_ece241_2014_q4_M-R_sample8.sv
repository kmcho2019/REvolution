module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_out = 1'b0;
    reg and_out = 1'b0;
    reg or_out = 1'b0;
    
    // Intermediate combinational logic
    wire xor_in = x ^ xor_out;
    wire and_in = x & ~and_out;
    wire or_in = x | ~or_out;
    
    // Sequential logic
    always @(posedge clk) begin
        xor_out <= xor_in;
        and_out <= and_in;
        or_out <= or_in;
    end
    
    // Output logic
    assign z = ~(xor_out | and_out | or_out);

endmodule