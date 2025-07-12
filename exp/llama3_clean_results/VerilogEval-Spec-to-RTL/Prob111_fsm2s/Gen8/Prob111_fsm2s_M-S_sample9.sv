module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
        out <= 1'b0;
    end else begin
        case (state)
            1'b0: begin
                if (j) begin
                    state <= 1'b1;
                    out <= 1'b1;
                end
            end
            1'b1: begin
                if (~k) begin
                    state <= state;
                    out <= 1'b1;
                end else begin
                    state <= 1'b0;
                    out <= 1'b0;
                end
            end
        endcase
    end
end

endmodule