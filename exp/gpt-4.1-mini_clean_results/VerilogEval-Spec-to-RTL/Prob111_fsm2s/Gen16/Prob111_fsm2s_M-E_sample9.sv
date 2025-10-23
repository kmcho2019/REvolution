module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // OFF state
            out <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // OFF
                    if (j)
                        state <= 1'b1; // Move to ON
                    out <= 1'b0;
                end
                1'b1: begin // ON
                    if (k)
                        state <= 1'b0; // Move to OFF
                    out <= 1'b1;
                end
                default: begin
                    state <= 1'b0;
                    out <= 1'b0;
                end
            endcase
        end
    end

endmodule