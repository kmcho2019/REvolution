module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Clear state encoding with minimal bits
    parameter B = 1'b1;
    parameter A = 1'b0;

    reg state;

    // Efficient state transitions with explicit conditions
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

    // Minimal output logic with continuous assignment
    assign out = (state == B);

endmodule