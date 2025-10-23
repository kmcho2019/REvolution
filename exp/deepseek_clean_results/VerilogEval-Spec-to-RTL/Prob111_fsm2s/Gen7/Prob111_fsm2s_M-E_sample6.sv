module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg state;

    // Toggle-based state transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            // Toggle when: (OFF and j=1) or (ON and k=1)
            state <= state ^ ((~state & j) | (state & k));
        end
    end

    // Moore output
    assign out = state;

endmodule