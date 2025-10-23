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
    
    // Combined state transition and register update
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
    
    // Output remains simple combinational logic
    assign out = state;
    
endmodule