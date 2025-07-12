module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // 0=A, 1=B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in;      // A -> A (if in=1), A -> B (if in=0)
                1'b1: state <= in;      // B -> B (if in=1), B -> A (if in=0)
            endcase
        end
    end

    assign out = state;

endmodule