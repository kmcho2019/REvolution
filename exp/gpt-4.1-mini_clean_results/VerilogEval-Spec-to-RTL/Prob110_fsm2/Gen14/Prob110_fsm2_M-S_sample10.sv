module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output reg  out
);

    reg state; // 0 = OFF, 1 = ON

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
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