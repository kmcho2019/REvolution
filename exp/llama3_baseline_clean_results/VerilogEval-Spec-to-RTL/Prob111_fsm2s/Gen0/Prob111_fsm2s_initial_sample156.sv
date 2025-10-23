module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // state can be either 0 (OFF) or 1 (ON)

// define the next state logic
always @(posedge clk) begin
    if (reset) begin // reset to OFF state
        state <= 0;
        out <= 0;
    end else begin
        case (state)
            0: begin // current state is OFF
                if (j) begin // if j is 1, transition to ON state
                    state <= 1;
                    out <= 1;
                end else begin // if j is 0, stay in OFF state
                    state <= 0;
                    out <= 0;
                end
            end
            1: begin // current state is ON
                if (k) begin // if k is 1, transition to OFF state
                    state <= 0;
                    out <= 0;
                end else begin // if k is 0, stay in ON state
                    state <= 1;
                    out <= 1;
                end
            end
        endcase
    end
end

endmodule