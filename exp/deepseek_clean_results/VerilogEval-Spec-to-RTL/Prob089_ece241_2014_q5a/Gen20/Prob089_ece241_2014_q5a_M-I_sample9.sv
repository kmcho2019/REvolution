module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg should_invert;  // State: 0 = copy, 1 = invert bits

    // Combinational output logic
    assign z = should_invert ? ~x : x;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            should_invert <= 1'b0;
        end else if (!should_invert) begin
            should_invert <= x;  // Transition to invert state on first '1'
        end
    end

endmodule