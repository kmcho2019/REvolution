module TopModule(
    input clk,
    input x,
    output reg z
);
    reg xor_out = 1'b0, and_out = 1'b0, or_out = 1'b0;
    
    // Calculate the gate outputs
    wire xor_result, and_result, or_result;
    assign xor_result = x ^ xor_out;
    assign and_result = x & ~and_out;
    assign or_result = x | ~or_out;
    
    // Update the D flip-flop states on the positive edge of the clock
    always @(posedge clk) begin
        xor_out <= xor_result;
        and_out <= and_result;
        or_out <= or_result;
    end
    
    // Calculate output z as the NOR of the registered states
    always @(*) begin
        z = ~(xor_out | and_out | or_out);
    end
endmodule