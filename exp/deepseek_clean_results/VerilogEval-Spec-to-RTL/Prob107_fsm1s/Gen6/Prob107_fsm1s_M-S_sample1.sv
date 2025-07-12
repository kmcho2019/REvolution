module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 0; // Reset to state B
        end else begin
            case (state)
                0: state <= in ? 0 : 1; // B transitions
                1: state <= in ? 1 : 0; // A transitions
            endcase
        end
    end

    assign out = ~state; // out=1 when state=B (0), out=0 when state=A (1)

endmodule