module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0;  // OFF state transitions
                1'b1: state <= k ? 1'b0 : 1'b1;  // ON state transitions
            endcase
        end
    end

    assign out = state;

endmodule