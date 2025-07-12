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
                1'b0: state <= j ? ~state : state;  // OFF state
                1'b1: state <= k ? ~state : state;  // ON state
            endcase
        end
    end

    assign out = state;

endmodule