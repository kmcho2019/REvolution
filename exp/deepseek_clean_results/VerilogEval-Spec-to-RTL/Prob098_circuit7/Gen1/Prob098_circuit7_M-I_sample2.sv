module TopModule (
    input clk,
    input a,
    output reg q
);

    // Initial state is q=1
    initial begin
        q = 1'b1;
    end

    always @(posedge clk) begin
        // Transition to q=0 when a=1 is detected and we're still in q=1 state
        if (q && a) begin
            q <= 1'b0;
        end
        // No else clause needed - q maintains its value automatically
    end

endmodule