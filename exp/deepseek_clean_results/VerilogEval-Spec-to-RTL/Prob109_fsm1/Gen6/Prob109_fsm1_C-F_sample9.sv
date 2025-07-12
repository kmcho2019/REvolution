module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // Next state logic using optimized XOR-based transition
    // State transitions:
    // B->A when in=0, B->B when in=1
    // A->B when in=0, A->A when in=1
    // This can be expressed as: next_state = state ^ ~in
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= state ^ ~in;  // XOR with ~in gives the desired transition
    end
    
    // Output logic (state is B)
    assign out = state;
    
endmodule