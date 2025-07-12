module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    reg state; // 0=OFF, 1=ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
        end
        else begin
            case (state)
                1'b0: state <= j ? 1'b1 : 1'b0;
                1'b1: state <= k ? 1'b0 : 1'b1;
            endcase
        end
        out <= state;
    end

endmodule