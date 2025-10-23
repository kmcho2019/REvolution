module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// State encoding
localparam OFF = 1'b0;
localparam ON  = 1'b1;

reg state;

// Sequential state and output update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
        out <= 1'b0;
    end else begin
        case(state)
            OFF: begin
                state <= j ? ON : OFF;
                out <= 1'b0; // Moore output depends only on state
            end
            ON: begin
                state <= k ? OFF : ON;
                out <= 1'b1;
            end
            default: begin
                state <= OFF;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule