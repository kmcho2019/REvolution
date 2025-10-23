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
    wire next_state;
    
    // Combinational next state logic
    assign next_state = (state == A) ? (in ? A : B) : (in ? B : A);
    
    // State register update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output logic
    assign out = (state == B);
    
endmodule