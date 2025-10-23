module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions with explicit encoding
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // Next state logic using case statement
    always @(*) begin
        case (state)
            A: state = in ? A : B;
            B: state = in ? B : A;
            default: state = B;
        endcase
    end
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end
    
    // Output logic remains combinational
    assign out = (state == B);
    
endmodule