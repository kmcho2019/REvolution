module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Using 1 bit for 2 states: OFF (0) and ON (1)
reg [0:0] next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        1'b0: begin // State OFF
            if (j) begin
                next_state = 1'b1; // Transition to ON if j is 1
            end else begin
                next_state = 1'b0; // Stay in OFF if j is 0
            end
        end
        1'b1: begin // State ON
            if (k) begin
                next_state = 1'b0; // Transition to OFF if k is 1
            end else begin
                next_state = 1'b1; // Stay in ON if k is 0
            end
        end
        default: next_state = 1'b0; // Default to OFF for any other state (shouldn't occur)
    endcase
end

// Output logic (Moore machine, output depends only on state)
assign out = state;

endmodule