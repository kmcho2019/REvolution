module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [0:0] state; // 1-bit signal to represent the state

// Initial state is OFF
initial state = 1'b0;

// Asynchronous reset
always @(posedge areset or negedge clk) begin
    if (areset) begin
        state <= 1'b0;
    end else begin
        // Combinatorial logic to determine next state
        case (state)
            1'b0: begin // State OFF
                if (j) begin
                    state <= 1'b1; // Transition to ON if j = 1
                end else begin
                    state <= 1'b0; // Stay in OFF if j = 0
                end
            end
            1'b1: begin // State ON
                if (k) begin
                    state <= 1'b0; // Transition to OFF if k = 1
                end else begin
                    state <= 1'b1; // Stay in ON if k = 0
                end
            end
        endcase
    end
end

// Output is directly driven by the current state
always @(*) begin
    out = state;
end

endmodule