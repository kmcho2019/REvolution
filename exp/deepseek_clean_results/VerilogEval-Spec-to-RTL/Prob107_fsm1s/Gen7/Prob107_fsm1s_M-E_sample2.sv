module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] state_shift;

    always @(posedge clk) begin
        if (reset) begin
            state_shift <= 2'b01; // Reset to state B (01)
        end else begin
            if (in) begin
                // Maintain current state (shift circularly)
                state_shift <= {state_shift[0], state_shift[1]};
            end else begin
                // Transition to other state (shift normally)
                state_shift <= {state_shift[0], 1'b0};
            end
        end
    end

    assign out = state_shift[0]; // LSB represents output

endmodule