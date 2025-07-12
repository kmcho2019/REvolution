module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0 for A, 1 for B

    // State transitions
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // A -> (in=1: A, in=0: B)
                1'b1: state <= in ? 1'b1 : 1'b0;  // B -> (in=1: B, in=0: A)
            endcase
        end
    end

    // Output assignment (Moore machine: output depends only on state)
    assign out = state;  // 1 for B, 0 for A

endmodule