module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // Two states: OFF (0) and ON (1)

always @(*) begin
    if (areset) begin // Asynchronous reset to OFF state
        state = 0;
        out = 0;
    end else begin
        case(state)
            0'b0: begin // State OFF
                if (j) begin
                    state = 1'b1; // Transition to ON state
                    out = 1'b1;
                end else begin
                    state = 1'b0; // Stay in OFF state
                    out = 1'b0;
                end
            end
            1'b1: begin // State ON
                if (k) begin
                    state = 1'b0; // Transition to OFF state
                    out = 1'b0;
                end else begin
                    state = 1'b1; // Stay in ON state
                    out = 1'b1;
                end
            end
        endcase
    end
end

endmodule