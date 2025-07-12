module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    localparam A = 1'b0, B = 1'b1;
    reg state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state and output logic (Moore machine)
    always @(*) begin
        case (state)
            B: begin
                out = 1'b1;
                next_state = (in) ? B : A;
            end
            A: begin
                out = 1'b0;
                next_state = (in) ? A : B;
            end
            default: begin
                out = 1'b1;   // Default output matches reset state B
                next_state = B;
            end
        endcase
    end

endmodule