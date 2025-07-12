module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Combined state and output register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to state A (z=0)
            z <= 1'b0;
        end else begin
            // State transition and output logic combined:
            // If in state A (z=0), output is x (transition to B if x=1)
            // If in state B (z=1), output is ~x (stay in B)
            z <= z ? ~x : x;
        end
    end

endmodule