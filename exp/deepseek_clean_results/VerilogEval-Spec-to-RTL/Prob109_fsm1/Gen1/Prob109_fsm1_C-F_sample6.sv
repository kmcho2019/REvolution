module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State definitions
    reg state;
    localparam A = 1'b0;  // Outputs 0
    localparam B = 1'b1;  // Outputs 1

    // State transition logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Async reset to state B
        end else begin
            case (state)
                A: state <= in ? A : B;  // A stays on 1, goes to B on 0
                B: state <= in ? B : A;  // B stays on 1, goes to A on 0
            endcase
        end
    end

    // Output logic - Moore machine (output depends only on state)
    assign out = state;  // Equivalent to: out = (state == B);

endmodule