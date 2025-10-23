module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    reg state;  // 0 = OFF, 1 = ON

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;
            out <= 1'b0;
        end else begin
            case (state)
                1'b0: begin  // OFF
                    state <= j ? 1'b1 : 1'b0;
                    out <= 1'b0;
                end
                1'b1: begin  // ON
                    state <= k ? 1'b0 : 1'b1;
                    out <= 1'b1;
                end
            endcase
        end
    end

endmodule