module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    reg out_reg;

    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 1'b0;  // Reset to OFF state (output=0)
        end else begin
            // Toggle logic:
            // - Set output when j=1 (regardless of current state)
            // - Clear output when k=1 (regardless of current state)
            // - Priority to k if both j and k are 1 (k overrides)
            if (k) begin
                out_reg <= 1'b0;
            end else if (j) begin
                out_reg <= 1'b1;
            end
            // Otherwise maintain current state
        end
    end

    assign out = out_reg;

endmodule