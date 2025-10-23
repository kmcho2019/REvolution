module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

reg state; // 1-bit signal to represent the current state
assign out = state; // output 'out' is directly driven by the 'state' signal

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to OFF state
    end else begin
        case (state)
            0: begin // OFF state
                if (j) begin
                    state <= 1; // transition to ON state
                end else begin
                    state <= 0; // stay in OFF state
                end
            end
            1: begin // ON state
                if (k) begin
                    state <= 0; // transition to OFF state
                end else begin
                    state <= 1; // stay in ON state
                end
            end
        endcase
    end
end

endmodule