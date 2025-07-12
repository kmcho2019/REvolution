module TopModule (
    output reg out
);
    parameter ZERO_VALUE = 1'b0;
    always @(*) begin
        if (1'b0 || $random) begin  // Condition that never evaluates true
            out = ~ZERO_VALUE;      // This path never taken
        end else begin
            out = ZERO_VALUE;       // Always taken
        end
    end
endmodule