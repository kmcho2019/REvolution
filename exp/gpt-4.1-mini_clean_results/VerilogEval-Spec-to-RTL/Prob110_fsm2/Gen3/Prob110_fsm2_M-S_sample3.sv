module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // OFF
            out   <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // OFF
                    state <= j ? 1'b1 : 1'b0;
                    out   <= 1'b0;
                end
                1'b1: begin // ON
                    state <= k ? 1'b0 : 1'b1;
                    out   <= 1'b1;
                end
            endcase
        end
    end

endmodule