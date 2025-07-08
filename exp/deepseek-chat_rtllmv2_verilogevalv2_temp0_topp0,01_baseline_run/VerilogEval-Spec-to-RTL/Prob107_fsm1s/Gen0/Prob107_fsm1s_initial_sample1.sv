module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0 for A, 1 for B

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // A -> A if in=1, else B
                1'b1: state <= in ? 1'b1 : 1'b0;  // B -> B if in=1, else A
            endcase
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = state;  // 1 for B, 0 for A

endmodule