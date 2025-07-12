module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define states
localparam OFF = 1'b0;
localparam ON = 1'b1;

reg state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset to OFF state
        state <= OFF;
        out <= OFF;
    end else begin
        case (state)
            OFF: begin
                if (j) begin
                    state <= ON;
                    out <= ON;
                end else begin
                    state <= OFF;
                    out <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    state <= OFF;
                    out <= OFF;
                end else begin
                    state <= ON;
                    out <= ON;
                end
            end
            default: begin
                state <= OFF;
                out <= OFF;
            end
        endcase
    end
end

endmodule