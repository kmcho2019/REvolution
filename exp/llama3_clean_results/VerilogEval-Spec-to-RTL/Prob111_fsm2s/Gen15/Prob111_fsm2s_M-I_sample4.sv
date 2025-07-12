module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // OFF state
        out <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // OFF state
                if (j) begin
                    state <= 2'b01; // Transition to ON state
                    out <= 1'b1;
                end else begin
                    state <= 2'b00; // Stay in OFF state
                    out <= 1'b0;
                end
            end
            2'b01: begin // ON state
                if (k) begin
                    state <= 2'b00; // Transition to OFF state
                    out <= 1'b0;
                end else begin
                    state <= 2'b01; // Stay in ON state
                    out <= 1'b1;
                end
            end
            default: begin
                state <= 2'b00; // Default to OFF state
                out <= 1'b0;
            end
        endcase
    end
end

endmodule