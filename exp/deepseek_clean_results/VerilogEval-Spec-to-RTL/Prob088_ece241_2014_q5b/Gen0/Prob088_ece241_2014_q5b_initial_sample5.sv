module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding
    parameter A = 2'b01;
    parameter B = 2'b10;
    
    reg [1:0] state, next_state;
    
    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = x ? B : A;
            B: next_state = B;
            default: next_state = A;
        endcase
    end
    
    // Output logic (Mealy)
    assign z = (state == A && x) || (state == B && !x);
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

endmodule