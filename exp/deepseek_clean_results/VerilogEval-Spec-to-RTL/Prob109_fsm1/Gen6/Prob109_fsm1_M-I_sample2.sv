module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;  // B=1, A=0

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // A -> A if in=1, else B
                1'b1: state <= in ? 1'b1 : 1'b0;  // B -> B if in=1, else A
            endcase
        end
    end

    assign out = state;  // Direct output

endmodule