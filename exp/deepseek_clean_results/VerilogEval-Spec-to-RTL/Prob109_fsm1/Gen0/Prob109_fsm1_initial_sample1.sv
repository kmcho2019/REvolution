module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding: 0 = A, 1 = B
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // A: 0->B, 1->A
                1'b1: state <= in ? 1'b1 : 1'b0;  // B: 0->A, 1->B
            endcase
        end
    end

    // Moore output depends only on current state
    assign out = state;  // B=1, A=0

endmodule