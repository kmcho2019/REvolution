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
                1'b0: state <= ~in;  // State B transition
                1'b1: state <= in;   // State A transition
            endcase
        end
    end

    assign out = ~state;  // out=1 when state=B, out=0 when state=A

endmodule