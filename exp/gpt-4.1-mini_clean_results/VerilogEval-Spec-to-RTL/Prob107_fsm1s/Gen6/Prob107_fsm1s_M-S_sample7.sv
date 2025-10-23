module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    parameter B = 1'b0, A = 1'b1;
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else begin
            case (state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B;
            endcase
        end
        // Moore output based on state
        out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule