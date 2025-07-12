module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State register (1=ON, 0=OFF)
    reg state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // Reset to OFF
        end else begin
            state <= state ? ~k : j;  // Compact transition logic
        end
    end

    // Output is the state directly (Moore machine)
    assign out = state;

endmodule