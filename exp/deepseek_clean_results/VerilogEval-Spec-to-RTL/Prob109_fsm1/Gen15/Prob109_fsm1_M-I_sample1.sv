module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions (B=1 outputs 1, A=0 outputs 0)
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    reg state;
    
    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
                default: state <= B;
            endcase
        end
    end
    
    // Output is simply the state bit
    assign out = state;
    
endmodule