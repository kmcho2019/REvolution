module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg state; // 1-bit signal to represent the current state

// Moore state machine's next state logic
always @(posedge clk) begin
    if (reset) begin // synchronous reset
        state <= 1'b0; // reset to OFF state
    end else begin
        case (state)
            1'b0: begin // current state is OFF
                if (j) begin
                    state <= 1'b1; // move to ON state
                end else begin
                    state <= 1'b0; // stay in OFF state
                end
            end
            1'b1: begin // current state is ON
                if (k) begin
                    state <= 1'b0; // move to OFF state
                end else begin
                    state <= 1'b1; // stay in ON state
                end
            end
        endcase
    end
end

// output logic (Moore output)
always @(*) begin
    case (state)
        1'b0: out <= 1'b0; // output is 0 when in OFF state
        1'b1: out <= 1'b1; // output is 1 when in ON state
    endcase
end

endmodule