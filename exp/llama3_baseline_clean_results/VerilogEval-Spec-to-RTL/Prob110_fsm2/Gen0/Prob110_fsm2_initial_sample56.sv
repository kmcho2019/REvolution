module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state; // 0 - OFF, 1 - ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Reset to OFF state
        out <= 0;
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // Transition to ON state if j=1
                    out <= 1;
                end else begin
                    state <= 0; // Stay in OFF state if j=0
                    out <= 0;
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // Transition to OFF state if k=1
                    out <= 0;
                end else begin
                    state <= 1; // Stay in ON state if k=0
                    out <= 1;
                end
            end
            default: state <= 0; // Default to OFF state for any other condition
        endcase
    end
end

endmodule