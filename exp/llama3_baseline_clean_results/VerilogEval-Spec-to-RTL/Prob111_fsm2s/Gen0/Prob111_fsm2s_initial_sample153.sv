module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

reg [0:0] state; // 0 for OFF, 1 for ON
reg [0:0] next_state;

// initial state
initial state = 0;

// output logic
assign out = state;

// next state logic
always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to OFF
    end else begin
        case(state)
            0: begin // OFF
                if (j) begin
                    state <= 1; // transition to ON
                end else begin
                    state <= 0; // stay in OFF
                end
            end
            1: begin // ON
                if (k) begin
                    state <= 0; // transition to OFF
                end else begin
                    state <= 1; // stay in ON
                end
            end
        endcase
    end
end

endmodule