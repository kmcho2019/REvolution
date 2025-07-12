module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg prev1, prev2;  // Stores previous two x values
    reg x_stable;      // Tracks if input is stable
    reg gated_clk;     // Gated clock signal

    // Simple clock gating when input is stable
    always @(*) begin
        gated_clk = clk & (~x_stable | ~aresetn);
    end

    always @(posedge gated_clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
            z <= 1'b0;
            x_stable <= 1'b0;
        end else begin
            prev2 <= prev1;
            prev1 <= x;
            z <= prev2 & ~prev1 & x;
            x_stable <= (prev1 == x);
        end
    end

endmodule