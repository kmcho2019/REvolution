module TopModule(
    input clk,
    input x,
    output z
);
    reg xor_out = 0, and_out = 0, or_out = 0;
    
    // Calculate the gate outputs
    wire xor_result, and_result, or_result;
    assign xor_result = x ^ xor_out;
    assign and_result = x & ~and_out;
    assign or_result = x | ~or_out;
    
    // Update the D flip-flop states on the positive edge of the clock
    always @(posedge clk) begin
        // Using non-blocking assignments to prevent race conditions
        xor_out <= #1 xor_result;
        and_out <= #1 and_result;
        or_out <= #1 or_result;
    end
    
    // Calculate output z as the NOR of the registered states
    assign z = ~(xor_out | and_out | or_out);
endmodule