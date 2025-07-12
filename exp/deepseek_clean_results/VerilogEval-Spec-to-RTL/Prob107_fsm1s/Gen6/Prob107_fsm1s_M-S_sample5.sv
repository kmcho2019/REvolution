module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to B
        end else begin
            case (state)
                1'b0: state <= ~in;  // B -> A when in=0
                1'b1: state <= in;    // A -> B when in=0
            endcase
        end
    end

    assign out = ~state;  // 1 when B, 0 when A

endmodule