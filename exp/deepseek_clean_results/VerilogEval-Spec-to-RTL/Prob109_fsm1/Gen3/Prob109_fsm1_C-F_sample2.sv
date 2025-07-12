module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions - output equals state value
    localparam A = 1'b0;
    localparam B = 1'b1;
    
    reg state;
    wire next_state;
    
    // Next state logic using case statement
    always @(*) begin
        case (state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
            default: next_state = B; // Safe default
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output is simply the state value
    assign out = state;
    
endmodule