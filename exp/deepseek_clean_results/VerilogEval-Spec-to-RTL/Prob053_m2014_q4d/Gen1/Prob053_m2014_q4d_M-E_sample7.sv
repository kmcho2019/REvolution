module TopModule (
    input clk,
    input in,
    output out
);

    reg state;

    // State transition logic
    always @(posedge clk) begin
        if (in) begin
            state <= ~state;  // Toggle state when input is high
        end
        // Else maintain current state (implicit)
    end

    // Output assignment
    assign out = state;

endmodule