module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state; // 0=B, 1=A

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // Reset to state B
        else case (state)
            1'b0: state <= in ? 1'b0 : 1'b1; // B transitions
            1'b1: state <= in ? 1'b1 : 1'b0; // A transitions
        endcase
    end

    assign out = ~state; // out=1 in B, out=0 in A

endmodule