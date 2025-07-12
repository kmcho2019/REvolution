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
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= (state == A) ? (in ? A : B) :  // if in state A
                     (in ? B : A);                  // if in state B
    end
    
    // Output is simply the state bit (B=1, A=0)
    assign out = state;
    
endmodule