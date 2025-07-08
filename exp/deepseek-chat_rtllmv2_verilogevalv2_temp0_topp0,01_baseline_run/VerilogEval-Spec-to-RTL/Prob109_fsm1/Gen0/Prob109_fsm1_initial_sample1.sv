module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    parameter A = 1'b0;
    parameter B = 1'b1;
    
    // State register
    reg state;
    
    // State transition and reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
            endcase
        end
    end
    
    // Output logic (Moore machine: output depends only on state)
    assign out = state;

endmodule