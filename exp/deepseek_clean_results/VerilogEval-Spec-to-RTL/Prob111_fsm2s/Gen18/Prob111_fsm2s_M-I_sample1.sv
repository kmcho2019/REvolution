module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;  // 0=OFF, 1=ON
    reg next_state;

    // Combinational state transition logic
    always @(*) begin
        if (reset) begin
            next_state = 1'b0;  // Reset to OFF
        end else begin
            case (state)
                1'b0: next_state = j ? 1'b1 : 1'b0;  // OFF state transitions
                1'b1: next_state = k ? 1'b0 : 1'b1;  // ON state transitions
                default: next_state = 1'b0;
            endcase
        end
    end

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output assignment (Moore style)
    assign out = state;

endmodule