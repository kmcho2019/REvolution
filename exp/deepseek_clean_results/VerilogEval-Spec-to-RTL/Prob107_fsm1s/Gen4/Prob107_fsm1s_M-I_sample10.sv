module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to state B
        end else begin
            case (state)
                1'b0: state <= in ? 1'b0 : 1'b1;  // B -> B if in=1, else -> A
                1'b1: state <= in ? 1'b1 : 1'b0;  // A -> A if in=1, else -> B
            endcase
        end
    end

    assign out = ~state;  // out=1 when state B (0), out=0 when state A (1)

endmodule