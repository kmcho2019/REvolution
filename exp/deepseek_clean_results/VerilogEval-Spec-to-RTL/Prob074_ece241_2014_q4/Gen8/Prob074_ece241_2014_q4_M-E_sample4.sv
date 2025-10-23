module TopModule (
    input clk,
    input x,
    output z
);

    parameter INIT_STATE = 3'b000;
    reg [2:0] state = INIT_STATE;
    
    always @(posedge clk) begin
        // Bit 0: XOR result (x ^ state[0])
        // Bit 1: AND result (x & ~state[1])
        // Bit 2: OR result (x | ~state[2])
        state <= {x | ~state[2], 
                 x & ~state[1], 
                 x ^ state[0]};
    end
    
    // Output is NOR of all state bits
    assign z = ~(|state);

endmodule