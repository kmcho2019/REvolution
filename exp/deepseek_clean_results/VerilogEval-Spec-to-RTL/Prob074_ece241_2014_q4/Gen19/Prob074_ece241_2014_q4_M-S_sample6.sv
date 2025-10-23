module TopModule (
    input clk,
    input x,
    output z
);

    // Combined state vector [xor, and, or]
    reg [2:0] state = 3'b0;
    
    always @(posedge clk) begin
        state[0] <= x ^ state[0];     // XOR
        state[1] <= x & ~state[1];    // AND
        state[2] <= x | ~state[2];    // OR
    end
    
    // NOR of all state bits
    assign z = ~|state;

endmodule