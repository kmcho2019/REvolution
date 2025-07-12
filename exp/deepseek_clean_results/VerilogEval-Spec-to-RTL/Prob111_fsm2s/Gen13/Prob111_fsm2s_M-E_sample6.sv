module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // T-flipflop implementation with gated clock
    reg state;
    wire toggle_condition = (state == 1'b0) ? j : k;
    wire gated_clk = clk & toggle_condition;

    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF state
        end else begin
            state <= ~state;  // Toggle state
        end
    end

    assign out = state;

endmodule