module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;

    // Combined state transition and output logic
    assign z = state_A ^ x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            state_A <= state_A & ~x;
        end
    end

endmodule