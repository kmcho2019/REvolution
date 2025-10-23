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
    
    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
                default: state <= B;
            endcase
        end
    end
    
    // Output is simply the state bit (B=1)
    assign out = state;
    
endmodule