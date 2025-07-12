module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    reg state;
    parameter B = 1'b0;
    parameter A = 1'b1;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= in ? B : A;
                A: state <= in ? A : B;
            endcase
        end
    end

    // Output logic (Moore style)
    assign out = (state == B);

endmodule