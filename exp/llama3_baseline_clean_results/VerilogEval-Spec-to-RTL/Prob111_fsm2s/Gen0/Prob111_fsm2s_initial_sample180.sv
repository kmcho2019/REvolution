module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] current_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 1'b0; // Reset to OFF state
        out <= 1'b0;
    end else begin
        case (current_state)
            1'b0: begin // OFF state
                if (j) begin
                    current_state <= 1'b1; // Move to ON state
                    out <= 1'b1;
                end else begin
                    current_state <= 1'b0; // Stay in OFF state
                    out <= 1'b0;
                end
            end
            1'b1: begin // ON state
                if (k) begin
                    current_state <= 1'b0; // Move to OFF state
                    out <= 1'b0;
                end else begin
                    current_state <= 1'b1; // Stay in ON state
                    out <= 1'b1;
                end
            end
            default: current_state <= 1'b0; // Default to OFF state
        endcase
    end
end

endmodule