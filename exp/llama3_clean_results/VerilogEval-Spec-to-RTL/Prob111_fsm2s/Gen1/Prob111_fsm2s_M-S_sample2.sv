module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

// State register with synchronous reset
reg state;
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // OFF
        out <= 1'b0;
    end
    else begin
        case(state)
            1'b0: begin // OFF
                if (j == 1'b1) begin
                    state <= 1'b1; // ON
                    out <= 1'b1;
                end
                else begin
                    state <= 1'b0; // OFF
                    out <= 1'b0;
                end
            end
            1'b1: begin // ON
                if (k == 1'b1) begin
                    state <= 1'b0; // OFF
                    out <= 1'b0;
                end
                else begin
                    state <= 1'b1; // ON
                    out <= 1'b1;
                end
            end
        endcase
    end
end

endmodule